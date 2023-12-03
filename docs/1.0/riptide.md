# Riptide
A blazing fast framework, designed with developers in mind.

## Types

### ClientEvent
```lua
ClientEvent<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) → T...,
    Received: Signal<T...>,

    Fire: (self: ClientEvent<T...>, T...) → (),
    On: (self: ClientEvent<T...>, Callback: (T...) → ()) → () → ()
}
```

### ServerEvent
```lua
ServerEvent<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) → T...,
    Received: Signal<(Player, T...)>,

    Fire: (self: ServerEvent<T...>, Player: Player, T...) → (),
    FireAll: (self: ServerEvent<T...>, T...) → (),
    FireAllExcept: (self: ServerEvent<T...>, Except: Player, T...) → (),
    FireList: (self: ServerEvent<T...>, List: { Player }, T...) → (),
    FireWithFilter: (self: ServerEvent<T...>, Filter: (Player) → boolean, T...) → (),

    On: (self: ServerEvent<T...>, Callback: (Player, T...) → ()) → () → (),

    Ratelimit: (self: ServerEvent<T...>, Limit: number, Interval: number) → ()
}
```

### Function
```lua
Function<T..., U...> = {
    Id: string,
    Validate: (...unknown) → T...,

    SetCallback: (self: Function<T..., U...>, Callback: (Player, T...) → U...) → () → (),
    Call: (self: Function<T..., U...>, T...) → Future.Future<(boolean, U...)>,
    RateLimit: (self: Function<T..., U...>, Limit: number, Interval: number) → ()
}
```

### Singleton
```lua
Singleton = {
    Init: ( () → () )?,
    Start: ( () → () )?,

    Stepped: ( (Time: number, DeltaTime: number) → () )?,
    Heartbeat: ( (DeltaTime: number) → () )?,

    [string]: (...any) → ...any
}
```

## References

### Future
```lua
Riptide.Future: Future
```
Reference to [Future](https://util.redblox.dev/future.html), a lightweight class to represent asynchronous functions

### Guard
```lua
Riptide.Guard: Guard
```
Reference to [Guard](https://util.redblox.dev/guard.html), a runtime type checker

### AnonymousSignal
```lua
Riptide.AnonymousSignal: Signal
```
Reference to [Signal](https://util.redblox.dev/signal.html), a blazingly fast Signal implementation

### DefaultLogger
```lua
Riptide.DefaultLogger: Logger
```
Riptide's default logger, which logs all debug messages to the developer console

## Classes

### Event
```lua
Riptide.Event: Event
```
[A powerful networking implementation](/1.0/networking/event)

### Logger
```lua
Riptide.Logger: Logger
```
[A powerful logger based around events](/1.0/logger)

## Methods

### Ignite
```lua
Riptide.Ignite(
    Verbose: boolean? -- Log every event to the console?
) → Future<number>
```
Starts Riptide, loading all of the added singletons.
Returns the time it took to load wrapped in a Future.

### AddSingleton
```lua
Riptide.AddSingleton(Singleton: ModuleScript) → ()
```
Registers a singleton.

### AddSingletons
```lua
Riptide.AddSingletons(Path: Instance) → ()
```
Shallowly registers singletons from under an instance.

### CachedSignal
```lua
Riptide.CachedSignal<T...>(Name: string) → Signal<T...>
```
Creates a new cached signals.

Cached signals utilize [Signal](https://util.redblox.dev/signal.html) under the hood. All cached signals are put into a cache within Riptide, which can be accessed from anywhere within your codebase.

### Function
```lua
Riptide.Function<T..., U...>(
    Name: string,
    ValidateArgs: (...unknown) → T...,
    ValidateReturn: (...unknown) → U...
) → Function
```

