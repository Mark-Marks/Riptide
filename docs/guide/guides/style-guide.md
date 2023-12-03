# Style Guide
Riptide is styled according to a specific style guide, which helps create clean code.

### General Style
- **Variables** All variables are `PascalCase`
- **Functions** All functions are `PascalCase`
- **Arguments** All function arguments are `PascalCase`
- **Tables** All tables are `PascalCase`
- **Types** All types are `PascalCase`. Types should be declared for all top level variables & function arguments.

### Comments
Code should be as lightly commented as possible - the code you write should describe itself.
The only exception to this are public facing functions, which should always be documented.
```lua
--[=[
    Creates a new cached signal.

    Cached signals utilize `red-blox/signal` under the hood. The only difference is that they're cached - each Signal has a name, and you can get each Signal from anywhere in your codebase.

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
```