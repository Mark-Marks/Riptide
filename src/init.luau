--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Signal = require(ReplicatedStorage.Packages._Index["red-blox_signal@2.0.2"].signal)
local Future = require(ReplicatedStorage.Packages._Index["red-blox_future@1.0.1"].future)
local Spawn = require(ReplicatedStorage.Packages._Index["red-blox_spawn@1.0.0"].spawn)
local Guard = require(ReplicatedStorage.Packages._Index["red-blox_guard@1.0.1"].guard)

local Logger = require(script.Logger)
local Networking = require(script.Networking)

---------------------------------------------------
-- TYPES
---------------------------------------------------

export type Singleton = {
    Init: ( () -> () )?,
    Start: ( () -> () )?,

    Stepped: ( (Time: number, DeltaTime: number) -> () )?,
    Heartbeat: ( (DeltaTime: number) -> () )?,

    [string]: (...any) -> ...any
}

export type ClientEvent<T...> = Networking.ClientEvent<T...>
export type ServerEvent<T...> = Networking.ServerEvent<T...>
export type Function<T..., U...> = Networking.Function<T..., U...>

export type LoggerImpl = Logger.LoggerImpl
export type Logger = Logger.Logger
export type LoggerEvent = Logger.Event
export type LoggerEventType = Logger.EventType

---------------------------------------------------
-- SETUP
---------------------------------------------------

--[=[
    A minimal framework, designed with speed and ease of development in mind.

    Example usage for loading singletons:
    ```lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Riptide = require(ReplicatedStorage.Packages.Riptide)

    Riptide.AddSingletons(script)

    Riptide.Ignite():After(function(Took)
        Riptide.Logger.Default:Info(`Took {Took}s to load.`)
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

--- Reference to Riptide's default logger, which logs all `Debug` and `Info` events
--- @prop Logger.Default Logger
--- @within Riptide
Riptide.Default = Logger.Default

--- Reference to `Logger`
--- @prop Logger Logger
--- @within Riptide
Riptide.Logger = Logger.Logger

---------------------------------------------------
-- NETWORKING CONSTRUCTORS
---------------------------------------------------

-- Events

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

    Logger.Default:FatalAssert(RunService:IsClient(), "[Riptide] Event.Client: Can only be accessed from the client.")
    Logger.Default:FatalAssert(not Networking.Identifier.Exists(Name), "[Riptide] Event.Client: Cannot use the same name twice.")

    local Id = Networking.Identifier.Shared(Name):Await()

    return Networking.Event.Client.new(Id, Reliable, Validate) :: any
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

    Logger.Default:FatalAssert(RunService:IsServer(), "[Riptide] Event.Server: Can only be accessed from the server.")
    Logger.Default:FatalAssert(not Networking.Identifier.Exists(Name), "[Riptide] Event.Server: Cannot use the same name twice.")

    local Id = Networking.Identifier.Shared(Name):Await()

    return Networking.Event.Server.new(Id, Reliable, Validate)
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
function Riptide.Function<T..., U...>(Name: string, ValidateArgs: (...unknown) -> T..., ValidateReturn: (...unknown) -> U...): Function<T..., U...>
    return Networking.Function.new(Name, ValidateArgs, ValidateReturn)
end

---------------------------------------------------
-- FRAMEWORK
---------------------------------------------------

-- Cached Signal
local SignalCache: { [string]: Signal.Signal<...any> } = {}

--[=[
    Creates a new cached signal.

    Cached signals utilize Signal under the hood. All cached signals are put into a cache within Riptide, which can be accessed from anywhere within your codebase.

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
    Logger.Default:FatalAssert(not Ignited, "Riptide is already ignited.")
    Logger.Default:FatalAssert(not Modules[Singleton.Name], "Such a singleton already exists.")

    Modules[Singleton.Name] = Singleton
    Count += 1
end

--[=[
    Shallowly registers singletons.

    @within Riptide
    @param Path Instance
]=]
function Riptide.AddSingletons(Path: Instance)
    Logger.Default:FatalAssert(not Ignited, "Riptide is already ignited.")

    for _, Child in Path:GetChildren() do
        if not Child:IsA("ModuleScript") then continue end

        Logger.Default:FatalAssert(not Modules[Child.Name], "Such a singleton already exists.")

        Modules[Child.Name] = Child :: ModuleScript
        Count += 1
    end
end

--[=[
    Starts Riptide, loading all of the singletons.

    Returns the time it took to load everything.

    @within Riptide
    @param Verbose boolean? -- Should it log every event to the console?
    @return Future<number> -- Time it took to load wrapped in a Future
]=]
function Riptide.Ignite(Verbose: boolean?): Future.Future<number>
    Logger.Default:FatalAssert(not Ignited, "Riptide is already ignited.")

    return Future.new(function()
        local function Log(Message: string, Verbose: boolean?)
            if not Verbose then return end
            Logger.Default:Debug(Message)
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
            Networking.Net.Server.Start()
        else
            Networking.Net.Client.Start()
        end

        return os.clock()-Started
    end)
end

return Riptide