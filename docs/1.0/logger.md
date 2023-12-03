# Logger
Event based logger object. More information at [logger](/guide/guides/logging).

### Events
Events consist of an unix timestamp, a level and an attached message.
```lua
type Event = {
    Time: number,
    Type: "Info" | "Debug" | "Warn" | "Error" | "Fatal",
    Message: string
}
```
The `Error` log level doesn't stop code execution - `Fatal` on the other hand, halts execution and throws an error to the developer console.

## Types

### Event
```lua
Event = {
    Time: number,
    Type: "Info" | "Debug" | "Warn" | "Error" | "Fatal",
    Message: string
}
```

## Methods

### new
```lua
Logger.new() → Logger
```
Constructs a Logger.

### Info
```lua
Logger.Info(
    self: Logger,
    Message: string
) → Event
```
Logs at the `Info [🔵]` level.

### Debug
```lua
Logger.Debug(
    self: Logger,
    Message: string
) → Event
```
Logs at the `Debug [🟡]` level.

### Warn
```lua
Logger.Warn(
    self: Logger,
    Message: string
) → Event
```
Logs at the `Warn [🟠]` level.

### Error
```lua
Logger.Error(
    self: Logger,
    Message: string
) → Event
```
Logs at the `Error [🔴]` level.

### Fatal
```lua
Logger.Fatal(
    self: Logger,
    Message: string
) → Event
```
Logs at the `Fatal [❌]` level and spits out an error to the developer console, halting code execution.

### Assert
```lua
Logger.Assert(
    self: Logger,
    Condition: boolean,
    Message: string
) → Event?
```
Performs a soft assertion at the `Error [🔴]` level.

### Assert
```lua
Logger.FatalAssert(
    self: Logger,
    Condition: boolean,
    Message: string
) → Event?
```
Performs a fatal assertion at the `Fatal [❌]` level, halting execution and erroring to the developer console if the condition is false.

### OnEvent
```lua
Logger.OnEvent(
    self: Logger,
    Type: EventType,
    Callback: (Event) → void
) → () → void -- Used to disconnect
```
Called every time an event of the specified level happens.

As an example, this logs every debug event to the developer console:
```lua
Logger:OnEvent("Debug", function(Event)
    print(`[🟡][🕒{Event.Time}]: {Event.Message}`)
end)
```

### OnAnyEvent
```lua
Logger.OnAnyEvent(
    self: Logger,
    Callback: (Event) → void
) → () → void -- Used to disconnect
```
Called every time any event happens.