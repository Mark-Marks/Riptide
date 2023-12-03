--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Signal = require(ReplicatedStorage.Packages._Index["red-blox_signal@2.0.2"].signal)
local Future = require(ReplicatedStorage.Packages._Index["red-blox_future@1.0.1"].future)
local Ratelimiter = require(ReplicatedStorage.Packages._Index["red-blox_ratelimit@1.0.1"].ratelimit)
local Guard = require(ReplicatedStorage.Packages._Index["red-blox_guard@1.0.1"].guard)
local Spawn = require(ReplicatedStorage.Packages._Index["red-blox_spawn@1.0.0"].spawn)

--[=[
    A minimal framework, designed with speed and ease of development in mind.

    Example usage for loading singletons:
    ```lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Riptide = require(ReplicatedStorage.Packages.Riptide)

    Riptide.AddSingletons(script)

    Riptide.Ignite():After(function(Took)
        Riptide.DefaultLogger:Info(`Took {Took}s to load.`)
    end)
    ```

    @class Riptide
]=]
local Riptide = {}

--- Reference to `red-blox/guard`
--- @prop Guard Guard
--- @within Riptide
Riptide.Guard = Guard

--- Reference to `red-blox/future`
--- @prop Future Future
--- @within Riptide
Riptide.Future = Future

--- Reference to `red-blox/signal`
--- @prop AnonymousSignal Signal
--- @within Riptide
Riptide.AnonymousSignal = Signal

---------------------------------------------------
-- TYPES
---------------------------------------------------

export type ClientEvent<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) -> T...,
    Received: Signal.Signal<T...>,

    Fire: (self: ClientEvent<T...>, T...) -> (),
    On: (self: ClientEvent<T...>, Callback: (T...) -> ()) -> () -> ()
}

export type ServerEvent<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) -> T...,
    Received: Signal.Signal<(Player, T...)>,

    Fire: (self: ServerEvent<T...>, Player: Player, T...) -> (),
    FireAll: (self: ServerEvent<T...>, T...) -> (),
    FireAllExcept: (self: ServerEvent<T...>, Except: Player, T...) -> (),
    FireList: (self: ServerEvent<T...>, List: { Player }, T...) -> (),
    FireWithFilter: (self: ServerEvent<T...>, Filter: (Player) -> boolean, T...) -> (),

    On: (self: ServerEvent<T...>, Callback: (Player, T...) -> ()) -> () -> (),

    Ratelimit: (self: ServerEvent<T...>, Limit: number, Interval: number) -> ()
}

export type Function<T..., U...> = {
    Id: string,
    Validate: (...unknown) -> T...,

    SetCallback: (self: Function<T..., U...>, Callback: (Player, T...) -> U...) -> () -> (),
    Call: (self: Function<T..., U...>, T...) -> Future.Future<(boolean, U...)>,
    RateLimit: (self: Function<T..., U...>, Limit: number, Interval: number) -> ()
}

export type Singleton = {
    Init: (() -> ())?,
    Start: (() -> ())?,

    Stepped: ((Time: number, DeltaTime: number) -> ())?,
    Heartbeat: ((DeltaTime: number) -> ())?,

    [string]: (...any) -> ...any
}

export type EventType = "Info" | "Debug" | "Warn" | "Error" | "Fatal"

export type Event = {
    Time: number,
    Type: EventType,
    Message: string
}

export type LoggerImpl = {
    __index: LoggerImpl,

    new: () -> Logger,

    Info: (self: Logger, Message: string) -> Event,
    Debug: (self: Logger, Message: string) -> Event,
    Warn: (self: Logger, Message: string) -> Event,
    Error: (self: Logger, Message: string) -> Event,
    Fatal: (self: Logger, Message: string) -> Event,
    Assert: (self: Logger, Condition: boolean, Message: string) -> Event?,
    FatalAssert: (self: Logger, Condition: boolean, Message: string) -> Event?,

    OnEvent: (self: Logger, Type: EventType, Callback: (Event: Event) -> ()) -> () -> (),
    OnAnyEvent: (self: Logger, Callback: (Event: Event) -> ()) -> () -> ()
}

export type Logger = typeof(setmetatable({} :: {
    _Log: { Event },
    _Happened: Signal.Signal<Event>
}, {} :: LoggerImpl))

---------------------------------------------------
-- UTIL
---------------------------------------------------

-- Cached Signal

local SignalCache: { [string]: Signal.Signal<...any> } = {}

--[=[
    Creates a new cached signal.
    Cached signals utilize `red-blox/signal` under the hood. Their only difference is that they're cached - therefore you can give Signals names and get them from other places.

    @within Riptide
    @param Name string
    @return Signal<Args>
]=]
function Riptide.CachedSignal<T...>(Name: string): Signal.Signal<T...>
    if SignalCache[Name] then return SignalCache[Name] end

    local NewSignal: Signal.Signal<T...> = Signal()
    SignalCache[Name] = NewSignal

    return NewSignal
end

-- Logger

local function ConstructEvent(Type: EventType, Message: string): Event
    return {
        Time = os.time(),
        Type = Type,
        Message = Message
    }
end

--[=[
    Logger object, based around events.

    Only Fatal level events are logged to the developer console, though you can set up functions to log any event type you want utiling `Logger:OnEvent()`:
    ```lua
    local Logger = Riptide.Logger.new()
    Logger:OnEvent("Debug", function(Event)
        print(`[🟡][{Event.Time}]: {Event.Message}`)
    end)
    ```

    Logger contains 5 event types: `Info`, `Debug`, `Warn`, `Error`, `Fatal`.
    `Fatal` works the same as `error()` -- it halts execution.

    Events consist of the unix timestamp they happened at, their type and the message assigned to them.

    Logger can also be used for soft & fatal assertions -- soft assertions producing `Error` events, and fatal assertions producing `Fatal` events & halting execution.
    ```lua
    Logger:FatalAssert(not Ignited, "Riptide is already ignited.") -- If `Ignited` is true, produces a `Fatal` event and halts execution. Works as a type refinement.
    Logger:Assert(Cookies, "Grandma didn't bake cookies today 😟") -- If `Cookies` is false, produces an `Error` event, but continues execution.
    ```

    @class Logger
]=]
local Logger = {} :: LoggerImpl
Logger.__index = Logger

--[=[
    Creates a new Logger.

    @return Logger
]=]
function Logger.new(): Logger
    local self = {
        _Log = {},
        _Happened = Signal()
    }

    return setmetatable(self, Logger)
end

--[=[
    Logs at the `Info [🔵]` level.

    @param Message string
    @return Event
]=]
function Logger.Info(self: Logger, Message: string): Event
    local Event = ConstructEvent("Info", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)

    return Event
end

--[=[
    Logs at the `Debug [🟡]` level.

    @param Message string
    @return Event
]=]
function Logger.Debug(self: Logger, Message: string): Event
    local Event = ConstructEvent("Debug", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)

    return Event
end

--[=[
    Logs at the `Warn [🟠]` level.

    @param Message string
    @return Event
]=]
function Logger.Warn(self: Logger, Message: string): Event
    local Event = ConstructEvent("Warn", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)

    return Event
end

--[=[
    Logs at the `Error [🔴]` level.

    @param Message string
    @return Event
]=]
function Logger.Error(self: Logger, Message: string): Event
    local Event = ConstructEvent("Error", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)

    return Event
end

--[=[
    Logs at the `Fatal [❌]` level.

    @param Message string
    @return Event
]=]
function Logger.Fatal(self: Logger, Message: string): Event
    local Event = ConstructEvent("Fatal", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)
    error(`[❌]: {Message}`)

    return Event
end

--[=[
    Asserts at the `Error [🔴]` level.

    @param Condition boolean
    @param Message string
    @return Event?
]=]
function Logger.Assert(self: Logger, Condition: boolean, Message: string): Event?
    if Condition then return end

    local Event = ConstructEvent("Error", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)

    return Event
end

--[=[
    Asserts at the `Fatal [❌]` level.

    @param Condition boolean
    @param Message string
    @return Event?
]=]
function Logger.FatalAssert(self: Logger, Condition: boolean, Message: string): Event?
    if Condition then return end

    local Event = ConstructEvent("Fatal", Message)

    table.insert(self._Log, Event)
    self._Happened:Fire(Event)
    assert(Condition, `[❌]: {Message}`)

    return Event
end

--[=[
    Called every time an event happens, and it's of your given type.
    As an example, this logs every debug statement:
    ```lua
    Logger:OnEvent("Debug", function(Event)
        print(`[🟡][{Event.Time}]: {Event.Message}`)
    end)
    ```

    @param Type EventType
    @param Callback (Event) -> void
    @return () -> void -- Used to disconnect
]=]
function Logger.OnEvent(self: Logger, Type: EventType, Callback: (Event: Event) -> ()): () -> ()
    return self._Happened:Connect(function(Event)
        if Event.Type ~= Type then return end
        Callback(Event)
    end)
end

--[=[
    Called every time an event happens.

    @param Callback (Event) -> void
    @return () -> void -- Used to disconnect
]=]
function Logger.OnAnyEvent(self: Logger, Callback: (Event: Event) -> ()): () -> ()
    return self._Happened:Connect(Callback)
end

--- Reference to the `Logger` class
--- @prop Logger Logger
--- @within Riptide
Riptide.Logger = Logger

local DefaultLogger = Logger.new()
DefaultLogger:OnEvent("Debug", function(Event)
    print(`[🟡][🕒{Event.Time}]: {Event.Message}`)
end)
DefaultLogger:OnEvent("Info", function(Event)
    print(`[🔵][🕒{Event.Time}]: {Event.Message}`)
end)

--- Reference to Riptide's default logger, which logs all `Debug` and `Info` events
--- @prop DefaultLogger Logger
--- @within Riptide
Riptide.DefaultLogger = DefaultLogger

---------------------------------------------------
-- NETWORKING
---------------------------------------------------

-- Backend

local InternalClientNet = {}
do
    local ListenerMap: { [string]: ({ any }) -> () } = {}
    local CallMap: { [string]: thread } = {}
    local Outgoing: {
        Reliable: { [string]: { { any } } },
        Unreliable: { [string]: { { any } } },
        Call: { [string]: { { any } } }
    } = {
        Reliable = {},
        Unreliable = {},
        Call = {}
    }

    function InternalClientNet.SendReliableEvent(EventId: string, CallList: { any })
        if not Outgoing.Reliable[EventId] then
            Outgoing.Reliable[EventId] = {}
        end

        table.insert(Outgoing.Reliable[EventId], CallList)
    end

    function InternalClientNet.SendUnreliableEvent(EventId: string, CallList: { any })
        if not Outgoing.Unreliable[EventId] then
            Outgoing.Unreliable[EventId] = {}
        end

        table.insert(Outgoing.Unreliable[EventId], CallList)
    end

    function InternalClientNet.SetListener(EventId: string, Callback: ({ any }) -> ())
        ListenerMap[EventId] = Callback
    end

    function InternalClientNet.CallAsync(EventId: string, CallList: { any }): { any }
        if not Outgoing.Call[EventId] then
            Outgoing.Call[EventId] = {}
        end

        table.insert(Outgoing.Call[EventId], CallList)
        CallMap[CallList[1]] = coroutine.running()

        return coroutine.yield()
    end

    function InternalClientNet.Start()
        local ReliableRemote = ReplicatedStorage:WaitForChild("ReliableRedEvent") :: RemoteEvent
        local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: UnreliableRemoteEvent

        ReliableRemote.OnClientEvent:Connect(function(IncomingFireSection, IncomingCallSection)
            if IncomingFireSection then
                for EventId, CallList in IncomingFireSection do
                    local Listener = ListenerMap[EventId]
                    if not Listener then continue end

                    for _, Call in CallList do
                        Listener(Call)
                    end
                end
            end

            if not IncomingCallSection then return end

            for CallId, CallList in IncomingCallSection do
                local CallThread = CallMap[CallId]
                if not CallThread then continue end

                coroutine.resume(CallThread, table.unpack(CallList))
                CallMap[CallId] = nil
            end
        end)

        UnreliableRemote.OnClientEvent:Connect(function(IncomingFireSection)
            if not IncomingFireSection then return end

            for EventId, CallList in IncomingFireSection do
                local Listener = ListenerMap[EventId]
                if not Listener then continue end

                for _, Call in CallList do
                    Listener(Call)
                end
            end
        end)

        RunService.Heartbeat:Connect(function()
            if next(Outgoing.Reliable) or next(Outgoing.Call) then
                ReliableRemote:FireServer(Outgoing.Reliable, Outgoing.Call)

                Outgoing.Reliable = {}
                Outgoing.Call = {}
            end

            if not next(Outgoing.Unreliable) then return end

            UnreliableRemote:FireServer(Outgoing.Unreliable)

            Outgoing.Unreliable = {}
        end)
    end
end

local InternalServerNet = {}
do
    local FireSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))
    local CallSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))

    local ListenerMap: { [string]: (Player, { any }) -> () } = {}
    local OutgoingMap: {
        [Player]: {
            Reliable: { [string]: { { any } } },
            Unreliable: { [string]: { { any } } },
            CallReturn: { [string]: { any } }
        }
    } = {}

    function InternalServerNet.SendReliableEvent(Player: Player, EventId: string, Args: { any })
        if not OutgoingMap[Player] then
            OutgoingMap[Player] = {
                Reliable = {},
                Unreliable = {},
                CallReturn = {}
            }
        end

        if not OutgoingMap[Player].Reliable[EventId] then
            OutgoingMap[Player].Reliable[EventId] = {}
        end

        table.insert(OutgoingMap[Player].Reliable[EventId], Args)
    end

    function InternalServerNet.SendUnreliableEvent(Player: Player, EventId: string, Args: { any })
        if not OutgoingMap[Player] then
            OutgoingMap[Player] = {
                Reliable = {},
                Unreliable = {},
                CallReturn = {}
            }
        end

        if not OutgoingMap[Player].Unreliable[EventId] then
            OutgoingMap[Player].Unreliable[EventId] = {}
        end

        table.insert(OutgoingMap[Player].Unreliable[EventId], Args)
    end

    function InternalServerNet.Listen(EventId: string, Callback: (Player, { any }) -> ())
        ListenerMap[EventId] = Callback
    end

    function InternalServerNet.SendCallReturn(Player: Player, CallId: string, Args: { any })
        if not OutgoingMap[Player] then
            OutgoingMap[Player] = {
                Reliable = {},
                Unreliable = {},
                CallReturn = {}
            }
        end

        OutgoingMap[Player].CallReturn[CallId] = Args
    end

    function InternalServerNet.Start()
        local ReliableRemote = ReplicatedStorage:WaitForChild("ReliableRedEvent") :: RemoteEvent
        local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: UnreliableRemoteEvent

        ReliableRemote.OnServerEvent:Connect(function(Player, IncomingFireSection, IncomingCallSection)
            local FireSectionValid, FireSection = FireSectionCheck(IncomingFireSection)

            if FireSectionValid then
                for EventId, CallList in FireSection do
                    local Listener = ListenerMap[EventId]
                    if not Listener then return end

                    for _, Call in CallList do
                        Listener(Player, Call)
                    end
                end
            end

            local CallSectionValid, CallSection = CallSectionCheck(IncomingCallSection)
            if not CallSectionValid then return end

            for EventId, CallList in CallSection do
                local Listener = ListenerMap[EventId]

                if Listener then
                    for _, Call in CallList do
                        Listener(Player, Call)
                    end
                    continue
                end

                for _, Call in CallList do
                    local CallId = Call[1]

                    InternalServerNet.SendCallReturn(Player, CallId, { false, "Event has no listener." })
                end
            end
        end)

        UnreliableRemote.OnServerEvent:Connect(function(Player, IncomingFireSection)
            local FireSectionValid, FireSection = FireSectionCheck(IncomingFireSection)
            if not FireSectionValid then return end

            for EventId, CallList in FireSection do
                local Callback = ListenerMap[EventId]
                if not Callback then continue end

                for _, Call in CallList do
                    Callback(Player, Call)
                end
            end
        end)

        RunService.Heartbeat:Connect(function()
            for Player, Outgoing in OutgoingMap do
                if next(Outgoing.Reliable) or next(Outgoing.CallReturn) then
                    ReliableRemote:FireClient(Player, Outgoing.Reliable, Outgoing.CallReturn)
                end

                if next(Outgoing.Unreliable) then
                    UnreliableRemote:FireClient(Player, Outgoing.Unreliable)
                end

                OutgoingMap[Player] = nil
            end
        end)
    end

    if RunService:IsServer() then
        if not ReplicatedStorage:FindFirstChild("ReliableRedEvent") then
            local ReliableRemote = Instance.new("RemoteEvent")
            ReliableRemote.Name = "ReliableRedEvent"
            ReliableRemote.Parent = ReplicatedStorage
        end

        if not ReplicatedStorage:FindFirstChild("UnreliableRedEvent") then
            local UnreliableRemote = Instance.new("UnreliableRemoteEvent")
            UnreliableRemote.Name = "UnreliableRedEvent"
            UnreliableRemote.Parent = ReplicatedStorage
        end

        if not ReplicatedStorage:FindFirstChild("RedEvent") then
            local RedEvent = Instance.new("RemoteEvent")
            RedEvent.Name = "RedEvent"
            RedEvent.Parent = ReplicatedStorage
        end
    end
end

local Identifier = {}
do
    local Remote = ReplicatedStorage:WaitForChild("RedEvent")
    
    local NextShared = 0
    local NextUnique = 0

    local function UInt(Integer: number)
        return string.pack(`I{math.ceil(math.log(Integer + 1, 2) / 8)}`, Integer)
    end

    function Identifier.Shared(Name: string)
        return Future.new(function(Name: string)
            if RunService:IsServer() then
                if Remote:GetAttribute(Name) then
                    return Remote:GetAttribute(Name)
                end

                NextShared += 1
                local Id = UInt(NextShared)

                Remote:SetAttribute(Name, Id)

                return Id
            end

            while not Remote:GetAttribute(Name) do
                Remote.AttributeChanged:Wait()
            end

            return Remote:GetAttribute(Name)
        end, Name)
    end

    function Identifier.Exists(Name: string)
        return RunService:IsServer() and Remote:GetAttribute(Name) ~= nil
    end

    function Identifier.Unique()
        NextUnique += 1

        if NextUnique == 0xFFFF then
            NextUnique = 0
        end

        return UInt(NextUnique)
    end
end

-- Frontend

--[=[
    A blazingly fast remote function.

    Server side
    ```lua
    local GetMoney = Riptide.Function(
        "GetMoney",
        function() end,
        function(Money)
            return Riptide.Guard.Number(Money) -- Types the return as a Number
        end
    )

    GetMoney:Ratelimit(1, 1) -- Ratelimits the function to 1 call per second

    GetMoney:SetCallback(function(Player)
        return Data:GetMoney(Player)
    end)
    ```

    Client side
    ```lua
    local GetMoney = Riptide.Function(
        "GetMoney",
        function() end,
        function(Money)
            return Riptide.Guard.Number(Money) -- Types the return as a Number
        end
    )

    local Money = GetMoney:Call():Await()
    ```

    @class Function
]=]
local Function = {}
do
    local Ratelimits: { [string]: (Key: Player) -> boolean } = {}

    --[=[
        Sets the callback of the remote function.
        ⚠️ Only callable on the server!

        @within Function
        @param Callback (Player, Args) -> Return
    ]=]
    local function SetCallback<T..., U...>(self: Function<T..., U...>, Callback: (Player, T...) -> U...)
        DefaultLogger:FatalAssert(RunService:IsServer(), "[Riptide] Function.SetCallback: Cannot set callback to function on client.")

        InternalServerNet.Listen(self.Id, function(Player, Args)
            local CallId = table.remove(Args, 1)
            if typeof(CallId) ~= "string" then return end

            Spawn(function(EventId: string, Player: Player, CallId: string, ...: any)
                local Ratelimit = Ratelimits[EventId]
                if Ratelimit and not Ratelimit(Player) then return end
                if not pcall(self.Validate, ...) then return end

                InternalServerNet.SendCallReturn(Player, CallId, table.pack(pcall(Callback, Player, ...)))
            end, self.Id, Player, CallId, table.unpack(Args))
        end)
    end

    --[=[
        Calls the remote function.
        ⚠️ Only callable on the client!

        @within Function
        @param ... -- Args
    ]=]
    local function Call<T..., U...>(self: Function<T..., U...>, ...: T...)
        DefaultLogger:FatalAssert(RunService:IsClient(), "[Riptide] Function.Call: Cannot call on the server.")

        return Future.new(function(...: T...)
            local CallId = Identifier.Unique()

            return table.unpack(InternalClientNet.CallAsync(self.Id, table.pack(CallId, ...)))
        end, ...)
    end

    --[=[
        Ratelimits the function.

        @within Function
        @param Limit number
        @param Interval number
    ]=]
    local function Ratelimit<T..., U...>(self: Function<T..., U...>, Limit: number, Interval: number)
        DefaultLogger:FatalAssert(RunService:IsServer(), "[Riptide] Function.Ratelimit: Cannot call on the client.")

        Ratelimits[self.Id] = Ratelimiter(Limit, Interval)
    end

    function Function.new<T..., U...>(Name: string, ValidateArgs: (...unknown) -> T..., ValidateReturn: (...unknown) -> U...): Function<T..., U...>
        DefaultLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Function.new: Cannot use the same name twice.")

        return {
            Id = Identifier.Shared(Name):Await(),
            Validate = ValidateArgs,

            SetCallback = SetCallback,
            Call = Call,
            Ratelimit = Ratelimit
        } :: any
    end
end

--[=[
    A client event.

    @class ClientEvent
]=]
local ClientEvent = {}
do
    --[=[
        Fires data to the server.

        @within ClientEvent
        @param ... -- Args
    ]=]
    local function Fire<T...>(self: ClientEvent<T...>, ...: T...)
        if self.Reliable then
            InternalClientNet.SendReliableEvent(self.Id, table.pack(...))
            return
        end

        InternalClientNet.SendUnreliableEvent(self.Id, table.pack(...))
    end
    
    --[=[
        Listens to data from the server.

        @within ClientEvent
        @param Callback (Args) -> void
        @return () -> () -- Used to disconnect
    ]=]
    local function On<T...>(self: ClientEvent<T...>, Callback: (T...) -> ()): () -> ()
        return self.Received:Connect(Callback)
    end

    function ClientEvent.new<T...>(Id: string, Reliable: boolean, Validate: (...unknown) -> T...): ClientEvent<T...>
        local self = {
            Id = Id,
            Reliable = Reliable,
            Validate = Validate,
            Received = Signal(),

            Fire = Fire,
            On = On
        }
        
        InternalClientNet.SetListener(self.Id, function(Args)
            self.Received:Fire(table.unpack(Args))
        end)

        return self :: any
    end
end

--[=[
    A server event.

    @class ServerEvent
]=]
local ServerEvent = {}
do
    local Ratelimits: { [string]: (Key: Player) -> boolean } = {}

    --[=[
        Fires data to the given player.

        @within ServerEvent
        @param Player
        @param ... -- Args
    ]=]
    local function Fire<T...>(self: ServerEvent<T...>, Player: Player, ...: T...)
        if self.Reliable then
            InternalServerNet.SendReliableEvent(Player, self.Id, table.pack(...))
            return
        end
    
        InternalServerNet.SendUnreliableEvent(Player, self.Id, table.pack(...))
    end
    
    --[=[
        Fires data to all players.

        @within ServerEvent
        @param ... -- Args
    ]=]
    local function FireAll<T...>(self: ServerEvent<T...>, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in Players:GetPlayers() do
            if self.Reliable then
                InternalServerNet.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            InternalServerNet.SendUnreliableEvent(Player, self.Id, Args)
        end
    end
    
    --[=[
        Fires data to every player except the given one.

        @within ServerEvent
        @param Except Player
        @param ... -- Args
    ]=]
    local function FireAllExcept<T...>(self: ServerEvent<T...>, Except: Player, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in Players:GetPlayers() do
            if Player == Except then continue end
    
            if self.Reliable then
                InternalServerNet.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            InternalServerNet.SendUnreliableEvent(Player, self.Id, Args)
        end
    end
    
    --[=[
        Fires data to a list of players.

        @within ServerEvent
        @param List { Player }
        @param ... -- Args
    ]=]
    local function FireList<T...>(self: ServerEvent<T...>, List: { Player }, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in List do
            if self.Reliable then
                InternalServerNet.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            InternalServerNet.SendUnreliableEvent(Player, self.Id, Args)
        end
    end
    
    --[=[
        Fires data to filtered players.

        @within ServerEvent
        @param Filter (Player) -> boolean
        @param ... -- Args
    ]=]
    local function FireWithFilter<T...>(self: ServerEvent<T...>, Filter: (Player) -> boolean, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in Players:GetPlayers() do
            if not Filter(Player) then continue end
    
            if self.Reliable then
                InternalServerNet.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            InternalServerNet.SendUnreliableEvent(Player, self.Id, Args)
        end
    end

    --[=[
        Listens to data from the client.
        All data from the client is validated first.

        @within ServerEvent
        @param Callback (Player, Args) -> void
        @return () -> () -- Used to disconnect
    ]=]
    local function On<T...>(self: ServerEvent<T...>, Callback: (Player, T...) -> ()): () -> ()
        return self.Received:Connect(Callback)
    end

    --[=[
        Ratelimits the event.

        @within ServerEvent
        @param Limit number
        @param Interval number
    ]=]
    local function Ratelimit<T...>(self: ServerEvent<T...>, Limit: number, Interval: number)
        Ratelimits[self.Id] = Ratelimiter(Limit, Interval)
    end

    function ServerEvent.new<T...>(Id: string, Reliable: boolean, Validate: (...unknown) -> T...): ServerEvent<T...>
        local self = {
            Id = Id,
            Reliable = Reliable,
            Validate = Validate,
            Received = Signal(),

            Fire = Fire,
            FireAll = FireAll,
            FireAllExcept = FireAllExcept,
            FireList = FireList,
            FireWithFilter = FireWithFilter,

            On = On,

            Ratelimit = Ratelimit
        }

        InternalServerNet.Listen(self.Id, function(Player, Args)
            Spawn(function()
                local Ratelimit = Ratelimits[self.Id]
                if Ratelimit and not Ratelimit(Player) then return end
                if not self.Validate(table.unpack(Args)) then return end

                self.Received:Fire(Player, table.unpack(Args))
            end)
        end)
        
        return self :: any
    end
end

--[=[
    Blazingly fast & typesafe networking, utilizing Red under the hood.

    ```lua
    -- Server
    local ValidateRole = Riptide.Guard.Or(Riptide.Guard.Literal("Murderer"), Riptide.Guard.Literal("Innocent"))
    local AssignRole = Riptide.Event.Server("AssignRole", true, function(Role)
        return ValidateRole(Role) -- Automatically types `Team` as `"Murderer" | "Innocent"`
    end)

    AssignRole:Fire(Murderer, "Murderer")
    ```

    ```lua
    -- Client
    local ValidateRole = Riptide.Guard.Or(Riptide.Guard.Literal("Murderer"), Riptide.Guard.Literal("Innocent"))
    local AssignRole = Riptide.Event.Client("AssignRole", true, function(Role)
        return ValidateRole(Role) -- Automatically types `Team` as `"Murderer" | "Innocent"`
    end)

    AssignRole:On(function(Role) -- `Role` is now `"Murder" | "Innocent"`
        LocalPlayer.Role.Value = Role
    end)
    ```

    @class Event
]=]
local Event = {}

--[=[
    Creates an event on the client.

    @param Name string
    @param Reliable boolean
    @param Validate (...unknown) -> Args -- Purely for typechecking, doesn't actually do anything
    @return ClientEvent
]=]
function Event.Client<T...>(Name: string, Reliable: boolean, Validate: (...unknown) -> T...): ClientEvent<T...>
    if not Reliable then
        Name ..= "U"
    end

    DefaultLogger:FatalAssert(RunService:IsClient(), "[Riptide] Event.Client: Can only be accessed from the client.")
    DefaultLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Event.Client: Cannot use the same name twice.")

    local Id = Identifier.Shared(Name):Await()

    return ClientEvent.new(Id, Reliable, Validate) :: any
end

--[=[
    Creates an event on the server.

    @param Name string
    @param Reliable boolean
    @param Validate (...unknown) -> T... -- Sanity checks the data sent from the player & provides typechecking
    @return ServerEvent
]=]
function Event.Server<T...>(Name: string, Reliable: boolean, Validate: (...unknown) -> T...): ServerEvent<T...>
    if not Reliable then
        Name ..= "U"
    end

    DefaultLogger:FatalAssert(RunService:IsServer(), "[Riptide] Event.Server: Can only be accessed from the server.")
    DefaultLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Event.Server: Cannot use the same name twice.")

    local Id = Identifier.Shared(Name):Await()

    return ServerEvent.new(Id, Reliable, Validate)
end

--- Reference to `Event`
--- @prop Event Event
--- @within Riptide
Riptide.Event = Event

--[=[
    Creates a remote function.

    @within Riptide
    @param Name string
    @param ValidateArgs (...unknown) -> T...
    @param ValidateReturn (...unknown) -> U...
    @return Function
]=]
function Riptide.MakeFunction<T..., U...>(Name: string, ValidateArgs: (...unknown) -> T..., ValidateReturn: (...unknown) -> U...): Function<T..., U...>
    return Function.new(Name, ValidateArgs, ValidateReturn)
end

---------------------------------------------------
-- FRAMEWORK
---------------------------------------------------

local Ignited = false

local Count: number = 0
local Modules: { [string]: ModuleScript } = {}
local Singletons: { [string]: Singleton } = {}

local Connections: {
    Stepped: Signal.Signal<number, number>,
    Heartbeat: Signal.Signal<number>
} = {
    Stepped = Signal(),
    Heartbeat = Signal()
}

--[=[
    Registers a singleton.

    @within Riptide
    @param Singleton ModuleScript
]=]
function Riptide.AddSingleton(Singleton: ModuleScript)
    DefaultLogger:FatalAssert(not Ignited, "Riptide is already ignited.")
    DefaultLogger:FatalAssert(not Modules[Singleton.Name], "Such a singleton already exists.")

    Modules[Singleton.Name] = Singleton
    Count += 1
end

--[=[
    Shallowly registers singletons.

    @within Riptide
    @param Path Instance
]=]
function Riptide.AddSingletons(Path: Instance)
    DefaultLogger:FatalAssert(not Ignited, "Riptide is already ignited.")

    for _, Child in Path:GetChildren() do
        if not Child:IsA("ModuleScript") then continue end

        DefaultLogger:FatalAssert(not Modules[Child.Name], "Such a singleton already exists.")

        Modules[Child.Name] = Child :: ModuleScript
        Count += 1
    end
end

--[=[
    Starts Riptide, loading all of the singletons.
    Returns the time it took to load everything.

    @within Riptide
    @param Verbose boolean? -- Should it log every event to the console?
    @return Future<number> -- Time it took to load
]=]
function Riptide.Ignite(Verbose: boolean?): Future.Future<number>
    DefaultLogger:FatalAssert(not Ignited, "Riptide is already ignited.")

    return Future.new(function()
        local function Log(Message: string, Verbose: boolean?)
            if not Verbose then return end
            DefaultLogger:Debug(Message)
        end

        local Started = os.clock()

        -- Load singletons
        for Name, Module in Modules do
            Log(`Loading singleton {Name}`, Verbose)
            Singletons[Name] = require(Module) :: Singleton
        end

        -- Initialize singletons
        for Name, Singleton in Singletons do
            if not Singleton.Init then continue end
            Log(`Initializing singleton {Name}`, Verbose)
            Singleton.Init()
        end

        -- Start singletons
        for Name, Singleton in Singletons do
            if not Singleton.Start then continue end
            Log(`Starting singleton {Name}`, Verbose)
            Spawn(Singleton.Start)
        end

        -- Connect to Stepped and Heartbeat
        for Name, Singleton in Singletons do
            if Singleton.Stepped then
                Log(`Connecting singleton {Name} to Stepped`, Verbose)
                Connections.Stepped:Connect(Singleton.Stepped)
            end
            if Singleton.Heartbeat then
                Log(`Connecting singleton {Name} to Heartbeat`, Verbose)
                Connections.Heartbeat:Connect(Singleton.Heartbeat)
            end
        end

        RunService.Stepped:Connect(function(Time: number, DeltaTime: number)
            Connections.Stepped:Fire(Time, DeltaTime)
        end)

        RunService.Heartbeat:Connect(function(DeltaTime: number)
            Connections.Heartbeat:Fire(DeltaTime)
        end)

        if RunService:IsServer() then
            InternalServerNet.Start()
        else
            InternalClientNet.Start()
        end

        return os.clock()-Started
    end)
end

return Riptide