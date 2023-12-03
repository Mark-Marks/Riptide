# Logging
Riptide exposes a logging library, which is based around Events.

## Events
Events consist of an unix timestamp, a level and an attached message.
```lua
type Event = {
    Time: number,
    Type: "Info" | "Debug" | "Warn" | "Error" | "Fatal",
    Message: string
}
```
The `Error` log level doesn't stop code execution - `Fatal` on the other hand, halts execution and throws an error to the developer console.

## Loggers
Loggers are created with `.Logger.new`:
```lua
local Logger = Riptide.Logger.new()
```

Loggers expose an API which creates & logs events of every type.
Loggers can also be used for asserting - fatally, and non-fatally. Fatal assertions halt code execution and act as type refinements.
```lua
Logger:FatalAssert(not Ignited, "Riptide is already ignited.") -- Halts execution & works as a type refinement
Logger:Assert(Cookies, "Grandma didn't bake cookies today 😟") -- Logs an `Error` event, but continues on with execution
```

Loggers by default don't log any events to the developer console, although you can bypass this by hooking your logger - which will be exlpained next.

## Hooking
Loggers can be **hooked**. Hooking allows you to run code for every event of a certain type, or for all events.

As an example, let's make a logger log `Debug` messages to the developer console:
```lua
Logger:OnEvent("Debug", function(Event)
    print(`[🟡][🕒{Event.Time}]: {Event.Message}`)
end)
```
Running `Logger:Debug("This is a debug")` should print `[🟡][🕒INSERT_TIME_HERE]: This is a debug` to the console.

Another example of hooking would be to make a log book, which allows you to view all events & organize them by time, type and their message.
You could also utilize hooking to send all `Fatal` events to some kind of central database, or to alert developers of them.