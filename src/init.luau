--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Signal = require(ReplicatedStorage.Packages.Signal)
local Future = require(ReplicatedStorage.Packages.Future)
local Ratelimiter = require(ReplicatedStorage.Packages.Ratelimit)
local Guard = require(ReplicatedStorage.Packages.Guard)
local Spawn = require(ReplicatedStorage.Packages.Spawn)

---------------------------------------------------
-- TYPES
---------------------------------------------------

export type ClientEvent<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) -> T...,

    Fire: (self: ClientEvent<T...>, T...) -> (),
    On: (self: ClientEvent<T...>, Callback: (T...) -> ()) -> ()
}

export type ServerEvent<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) -> T...,

    Fire: (self: ServerEvent<T...>, Player: Player, T...) -> (),
    FireAll: (self: ServerEvent<T...>, T...) -> (),
    FireAllExcept: (self: ServerEvent<T...>, Except: Player, T...) -> (),
    FireList: (self: ServerEvent<T...>, List: { Player }, T...) -> (),
    FireWithFilter: (self: ServerEvent<T...>, Filter: (Player) -> boolean, T...) -> (),

    On: (self: ServerEvent<T...>, Callback: (Player, T...) -> ()) -> (),

    Ratelimit: (self: ServerEvent<T...>, Limit: number, Interval: number) -> ()
}

export type Function<T..., U...> = {
    Id: string,
    Validate: (...unknown) -> T...,

    SetCallback: (self: Function<T..., U...>, Callback: (Player, T...) -> U...) -> (),
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

export type Character = {
    ["Body Colors"]: BodyColors,
    HumanoidRootPart: Part,
    Humanoid: Humanoid & {
        HumanoidDescription: HumanoidDescription,
        Animator: Animator
    },
    Head: Part & {
        face: Decal,
        Mesh: SpecialMesh
    },
    ["Left Arm"]: Part,
    ["Left Leg"]: Part,
    ["Right Arm"]: Part,
    ["Right Leg"]: Part,
    ["Torso"]: Part & {
        roblox: Decal
    }
} & Model

---------------------------------------------------
-- UTIL
---------------------------------------------------

--- Cached Signal

local SignalCache: { [string]: Signal.Signal<...any> } = {}

--[=[
    Creates a new cached signal.
    Cached signals utilize `red-blox/signal` under the hood. Their only difference is that they're cached - therefore you can give Signals names and get them from other places.

    @param Name string
    @return Signal<Args>
]=]
function CachedSignal<T...>(Name: string): Signal.Signal<T...>
    if SignalCache[Name] then return SignalCache[Name] end

    local NewSignal: Signal.Signal<T...> = Signal()
    SignalCache[Name] = NewSignal

    return NewSignal
end

--- Logger

local function ConstructEvent(Type: EventType, Message: string): Event
    return {
        Time = os.time(),
        Type = Type,
        Message = Message
    }
end

local Logger = {} :: LoggerImpl
Logger.__index = Logger

--[=[
    Creates a new Logger.
    Loggers log events. Only fatals are logged to the developer console, though you can set up functions to log any event type you want utilizing `Logger:OnEvent()`.

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
    Logs at the Info [🔵] level.

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
    Logs at the Debug [🟡] level.

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
    Logs at the Warn [🟠] level.

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
    Logs at the Error [🔴] level.

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
    Logs at the Fatal [❌] level.

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
    Asserts at the Error [🔴] level.

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
    Asserts at the Fatal [❌] level.

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


local GLogger = Logger.new()
GLogger:OnEvent("Debug", function(Event)
    print(`[🟡][{Event.Time}]: {Event.Message}`)
end)

--- Get Character

local function GetCharacter(Player: Player?): Future.Future<Character>
    return Future.new(function()
        if not Player then
            GLogger:FatalAssert(RunService:IsClient(), "GetCharacter() can only be called without arguemnts on the client.")

            local LocalPlayer = Players.LocalPlayer
            return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        end

        return (Player.Character or Player.CharacterAdded:Wait()) :: Character
    end)
end

---------------------------------------------------
-- NETWORKING
---------------------------------------------------

---- Backend

local InternalClientNet = {}
do
    local ListenerMap: { [string]: Signal.Signal<{ any }> } = {}
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

    function InternalClientNet.Listen(EventId: string, Callback: ({ any }) -> ())
        ListenerMap[EventId]:Connect(Callback)
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
        local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: RemoteEvent

        ReliableRemote.OnClientEvent:Connect(function(IncomingFireSection, IncomingCallSection)
            if IncomingFireSection then
                for EventId, CallList in IncomingFireSection do
                    local Listener = ListenerMap[EventId]
                    if not Listener then continue end

                    for _, Call in CallList do
                        Listener:Fire(Call)
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
                    Listener:Fire(Call)
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

    local ListenerMap: { [string]: Signal.Signal<Player, { any }> } = {}
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
        ListenerMap[EventId]:Connect(Callback)
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
        local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: RemoteEvent

        ReliableRemote.OnServerEvent:Connect(function(Player, IncomingFireSection, IncomingCallSection)
            local FireSectionValid, FireSection = FireSectionCheck(IncomingFireSection)

            if FireSectionValid then
                for EventId, CallList in FireSection do
                    local Callback = ListenerMap[EventId]
                    if not Callback then return end

                    for _, Call in CallList do
                        Callback:Fire(Player, Call)
                    end
                end
            end

            local CallSectionValid, CallSection = CallSectionCheck(IncomingCallSection)
            if not CallSectionValid then return end

            for EventId, CallList in CallSection do
                local Callback = ListenerMap[EventId]

                if Callback then
                    for _, Call in CallList do
                        Callback:Fire(Player, Call)
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
                    Callback:Fire(Player, Call)
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

local InternalFunction = {}
do
    local Ratelimits: { [string]: (Key: Player) -> boolean } = {}

    --[=[
        Sets the callback of the remote function.
        ⚠️ Only callable on the server!

        @param Callback (Player, Args) -> Return
    ]=]
    local function SetCallback<T..., U...>(self: Function<T..., U...>, Callback: (Player, T...) -> U...)
        GLogger:FatalAssert(RunService:IsServer(), "[Riptide] Function.SetCallback: Cannot set callback to function on client.")
        
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

        @param Args
    ]=]
    local function Call<T..., U...>(self: Function<T..., U...>, ...: T...)
        GLogger:FatalAssert(RunService:IsClient(), "[Riptide] Function.Call: Cannot call on the server.")

        return Future.new(function(...: T...)
            local CallId = Identifier.Unique()

            return table.unpack(InternalClientNet.CallAsync(self.Id, table.pack(CallId, ...)))
        end, ...)
    end

    --[=[
        Ratelimits the function.

        @param Limit number
        @param Interval number
    ]=]
    local function Ratelimit<T..., U...>(self: Function<T..., U...>, Limit: number, Interval: number)
        GLogger:FatalAssert(RunService:IsServer(), "[Riptide] Function.Ratelimit: Cannot call on the client.")

        Ratelimits[self.Id] = Ratelimiter(Limit, Interval)
    end

    function InternalFunction.new<T..., U...>(Name: string, ValidateArgs: (...unknown) -> T..., ValidateReturn: (...unknown) -> U...): Function<T..., U...>
        GLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Function.new: Cannot use the same name twice.")

        return {
            Id = Identifier.Shared(Name):Await(),
            Validate = ValidateArgs,

            SetCallback = SetCallback,
            Call = Call,
            Ratelimit = Ratelimit
        } :: any
    end
end

---- Frontend

local ClientEvent = {}
do
    --[=[
        Fires data to the server.

        @param Args
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

        @param Callback (Args) -> void
    ]=]
    local function On<T...>(self: ClientEvent<T...>, Callback: (T...) -> ())
        InternalClientNet.Listen(self.Id, function(Args)
            Spawn(Callback, table.unpack(Args))
        end)
    end

    function ClientEvent.new<T...>(Id: string, Reliable: boolean, Validate: (...unknown) -> T...): ClientEvent<T...>
        return {
            Id = Id,
            Reliable = Reliable,
            Validate = Validate,

            Fire = Fire,
            On = On
        } :: any
    end
end


local ServerEvent = {}
do
    local Ratelimits: { [string]: (Key: Player) -> boolean } = {}

    --[=[
        Fires data to the given player.

        @param Player
        @param Args
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

        @param Args
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

        @param Except Player
        @param Args
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

        @param List { Player }
        @param Args
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

        @param Filter (Player) -> boolean
        @param Args
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

        @param Callback (Player, Args) -> void
    ]=]
    local function On<T...>(self: ServerEvent<T...>, Callback: (Player, T...) -> ())
        InternalServerNet.Listen(self.Id, function(Player, Args)
            Spawn(function(self: ServerEvent<T...>, EventId: string, Player: Player, ...: any)
                local Ratelimit = Ratelimits[EventId]
                if Ratelimit and not Ratelimit(Player) then return end
                if not self.Validate(...) then return end
    
                Callback(Player, ...)
            end, self, self.Id, Player, table.unpack(Args))
        end)
    end

    --[=[
        Ratelimits the event.

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

            Fire = Fire,
            FireAll = FireAll,
            FireAllExcept = FireAllExcept,
            FireList = FireList,
            FireWithFilter = FireWithFilter,

            On = On,

            Ratelimit = Ratelimit
        }
        
        return self :: any
    end
end

local Event = {}

--[=[
    Creates an event on the client.

    ```lua
    local Riptide = require(?)

    local Event = Riptide.Event.Client("Say", true)

    Event:On(function(Message: string)
        print("The server said hello!")
    end)
    ```

    @param Name string
    @param Reliable boolean
    @param Validate (...unknown) -> Args -- Purely for typechecking, doesn't actually do anything
    @return ClientEvent
]=]
function Event.Client<T...>(Name: string, Reliable: boolean, Validate: (...unknown) -> T...): ClientEvent<T...>
    GLogger:FatalAssert(RunService:IsClient(), "[Riptide] Event.Client: Can only be accessed from the client.")
    GLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Event.Client: Cannot use the same name twice.")

    local Id = Identifier.Shared(Name):Await()

    return ClientEvent.new(Id, Reliable, Validate) :: any
end

--[=[
    Creates an event on the server.

    ```lua
    local Riptide = require(?)

    local Event = Riptide.Event.Server("Say", true, function(Message)
        return Riptide.Guard.String(Message)
    end)

    Event:FireAll("Hello!")
    ```

    @param Name string
    @param Reliable boolean
    @param Validate (...unknown) -> T... -- Sanity checks the data sent from the player & provides typechecking
    @return ServerEvent
]=]
function Event.Server<T...>(Name: string, Reliable: boolean, Validate: (...unknown) -> T...): ServerEvent<T...>
    GLogger:FatalAssert(RunService:IsServer(), "[Riptide] Event.Server: Can only be accessed from the server.")
    GLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Event.Server: Cannot use the same name twice.")

    local Id = Identifier.Shared(Name):Await()

    return ServerEvent.new(Id, Reliable, Validate)
end

--[=[
    Creates a remote function.

    ```lua
    local Riptide = require(?)

    -- Server
    local Function = Riptide.Function("RequestNumber",
        function(Seed)
            return Riptide.Guard.Number(Seed)
        end,
        function(Number)
            return Riptide.Guard.Number(Number)
        end
    )

    Function.
    ```
]=]
local function Function<T..., U...>(Name: string, ValidateArgs: (...unknown) -> T..., ValidateReturn: (...unknown) -> U...): Function<T..., U...>
    return InternalFunction.new(Name, ValidateArgs, ValidateReturn)
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

local function AddSingleton(Singleton: ModuleScript)
    GLogger:FatalAssert(not Ignited, "Riptide is already ignited.")
    GLogger:FatalAssert(not Modules[Singleton.Name], "Such a singleton already exists.")

    Modules[Singleton.Name] = Singleton
    Count += 1
end

local function AddSingletons(Path: Folder)
    GLogger:FatalAssert(not Ignited, "Riptide is already ignited.")

    for _, Child in Path:GetChildren() do
        if not Child:IsA("ModuleScript") then continue end

        GLogger:FatalAssert(not Modules[Child.Name], "Such a singleton already exists.")

        Modules[Child.Name] = Child :: ModuleScript
        Count += 1
    end
end

local function Ignite(Verbose: boolean?): Future.Future<number>
    GLogger:FatalAssert(not Ignited, "Riptide is already ignited.")

    return Future.new(function()
        local function Log(Message: string, Verbose: boolean?)
            if not Verbose then return end
            GLogger:Debug(Message)
        end

        local Started = os.clock()

        --- Load singletons
        for Name, Module in Modules do
            Log(`Loading singleton {Name}`, Verbose)
            Singletons[Name] = require(Module) :: Singleton
        end

        --- Initialize singletons
        for Name, Singleton in Singletons do
            if not Singleton.Init then continue end
            Log(`Initializing singleton {Name}`, Verbose)
            Singleton.Init()
        end

        --- Start singletons
        for Name, Singleton in Singletons do
            if not Singleton.Start then continue end
            Log(`Starting singleton {Name}`, Verbose)
            Spawn(Singleton.Start)
        end

        --- Connect to Stepped and Heartbeat
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

        return Started
    end)
end

return {
    Event = Event,
    RemoteFunction = Function,

    Logger = Logger,

    Guard = Guard,
    Future = Future,
    Signal = CachedSignal,
    AnonymousSignal = Signal,
    
    GetCharacter = GetCharacter,

    AddSingleton = AddSingleton,
    AddSingletons = AddSingletons,
    Ignite = Ignite
}