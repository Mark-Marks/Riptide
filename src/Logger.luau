--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages._Index["red-blox_signal@2.0.2"].signal)

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



local function ConstructEvent(Type: EventType, Message: string): Event
    return {
        Time = os.time(),
        Type = Type,
        Message = Message
    }
end

--[=[
    Logger object, based around events.

    Events consist of an unix timestamp, a level and an attached message.
    ```lua
    type Event = {
        Time: number,
        Type: "Info" | "Debug" | "Warn" | "Error" | "Fatal",
        Message: string
    }
    ```
    The `Error` level doesn't stop code execution - `Fatal` on the other hand, halts execution and throws an error to the developer console.

    Loggers expose an API which creates & logs events of every type. Loggers can also be used for asserting - fatally, and non-fatally. Fatal assertions halt code execution and act as type refinements.
    ```lua
    Logger:FatalAssert(not Ignited, "Riptide is already ignited.") -- Halts execution & works as a type refinement
    Logger:Assert(Cookies, "Grandma didn't bake cookies today 😟") -- Logs an `Error` event, but continues on with execution
    ```
    Loggers by default don't log any events to the developer console, although you can bypass this by hooking your logger - which will be exlpained next.

    Loggers can be hooked. Hooking allows you to run code for every event of a certain type, or for all events.

    As an example, let's make a logger log `Debug` messages to the developer console:
    ```lua
    Logger:OnEvent("Debug", function(Event)
        print(`[🟡][🕒{Event.Time}]: {Event.Message}`)
    end)
    ```
    Running `Logger:Debug("This is a debug")` should print `[🟡][🕒INSERT_TIME_HERE]: This is a debug to the console`.

    Another example of hooking would be to make a log book, which allows you to view all events & organize them by time, type and their message. You could also utilize hooking to send all `Fatal` events to some kind of central database, or to alert developers of them.

    @class Logger
]=]
local Logger = {} :: LoggerImpl
Logger.__index = Logger

--[=[
    Constructs a logger.

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
    Logs at the `Fatal [❌]` level and spits out an error to the developer console, halting code execution.

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
    Performs a soft assertion at the `Error [🔴]` level.

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
    Performs a fatal assertion at the `Fatal [❌]` level, halting execution and erroring to the developer console if the condition is false.

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
    Called every time an event of the specified level happens.

    As an example, this logs every debug event to the developer console:
    ```lua
    Logger:OnEvent("Debug", function(Event)
        print(`[🟡][{🕒Event.Time}]: {Event.Message}`)
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

local DefaultLogger = Logger.new()
DefaultLogger:OnEvent("Debug", function(Event)
    print(`[🟡][🕒{Event.Time}]: {Event.Message}`)
end)
DefaultLogger:OnEvent("Info", function(Event)
    print(`[🔵][🕒{Event.Time}]: {Event.Message}`)
end)

return {
    Logger = Logger,
    Default = DefaultLogger
}