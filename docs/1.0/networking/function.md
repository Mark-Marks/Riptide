# Function
A remote function. Constructed with [Function](/1.0/riptide#function-1).

Remote functions are only `Client -> Server -> Client`, never vice versa. This is to prevent many issues, including infinitely yielding the server.

::: code-group
```lua [server]
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

```lua [client]
local GetMoney = Riptide.Function(
    "GetMoney",
    function() end,
    function(Money)
        return Riptide.Guard.Number(Money) -- Types the return as a Number
    end
)

local Money = GetMoney:Call():Await()
```
:::

## Methods

### SetCallback
```lua
Function.SetCallback<T..., U...>(
    self: Function<T..., U...>,
    Callback: (
        Player,
        Args
    ) → U...
) → ()
```
Sets the callback of the remote function.
::: warning
Only callable on the server!
:::

### Call
```lua
Function.Call<T..., U...>(
    self: Function<T...,U...>,
    ...: T... -- Args
) → ()
```
Calls the remote function.
::: warning
Only callable on the client!
:::

### Ratelimit
```lua
Function.Ratelimit<T..., U...>(
    self: Function<T...,U...>,
    Limit: number,
    Interval: number
) → ()
```
Ratelimits the function.