# Ignition

## Singletons
Singletons consists of lifecycle methods, util methods for connecting to `Stepped` and `Heartbeat`, and any other functions you may want.
Each singleton's lifecycle methods are optional, allowing developers full control over them.
```lua
type Singleton = {
    Init: ( () -> () )?,
    Start: ( () -> () )?,

    Stepped: ( () -> () )?,
    Heartbeat: ( () -> () )?,

    [string]: (...any) -> ...any
}
```

Example singleton:
```lua
local Hello = {}

function Hello.Start()
    Hello.SayHello("World")
end

function Hello.SayHello(To: string)
    print(`Hello, {To}!`)
end

return Hello
```

## Adding Singletons
Singular singletons are added using `Riptide.AddSingleton`:
```lua
Riptide.AddSingleton(MySingleton)
```

Alternatively, you can make Riptide shallowly add all the singletons under an instance:
```lua
Riptide.AddSingletons(script.Singletons)
```

## Igniting
Riptide is ignited (started) using `Riptide.Ignite`:
```lua
Riptide.Ignite()
```

`Ignite` returns a Future, meaning you can execute code after Riptide finished loading;
```lua
Riptide.Ignite():After(function(Took)
    Riptide.DefaultLogger:Log(`Riptide took {Took} seconds to load.`)
end)
```