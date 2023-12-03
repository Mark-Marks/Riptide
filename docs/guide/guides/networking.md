# Networking
Riptide utilizes [Red](https://red.redblox.dev/) under the hood to create events, which introduces tons of bandwith & performance optimizations, alongside introducing full intellisense for events. Games can see up to a 75% reduction in bandwith usage by using Red over standard remotes.

## Events
Events are created using Riptide's `Event` library. All events require validation functions, which both act as a sanity check and provide intellisense.
Riptide exposes [Guard](https://util.redblox.dev/guard.html) for validation.

::: danger
Riptide doesn't wait until the client is ready before letting the server send data to it - if you care about full reliability within the first few seconds of the client loading, you need to implement it yourself.
:::

::: code-group
```lua [Server]
local ReplicateInfo = Riptide.Event.Server("Info", true, function(Info)
    return Riptide.Guard.String(Info)
end)
```

```lua [Client]
local ReplicateInfo = Riptide.Event.Client("Info", true, function(Info)
    return Riptide.Guard.String(Info)
end)
```
:::

This creates a reliable event named `Info`, with a validation function which checks whether `Info` is a string.

Now, let's make the client listen to data from the server:
::: code-group
```lua [Server]
local ReplicateInfo = Riptide.Event.Server("Info", true, function(Info)
    return Riptide.Guard.String(Info)
end)

ReplicateInfo:FireAll("Hello") -- If you type this out, you will get full autocompletion for the arguments
```

```lua [Client]
local ReplicateInfo = Riptide.Event.Client("Info", true, function(Info)
    return Riptide.Guard.String(Info)
end)

ReplicateInfo:On(function(Info) -- If you type this out, `Info` will be autocompleted to a string
    print(`The server says "{Info}"!`)
end)
```
:::

After running the script, the client will print out `The server says "Hello"!`.

## Functions
Functions are created using `.Function`. Functions, too, require validation functions.

::: code-group
```lua [Server]
local RequestNumber = Riptide.Function(
    "RequestNumber",
    function(Seed)
        return Riptide.Guard.Number(Seed)
    end,
    function(Number)
        return Riptide.Guard.Number(Number)
    end
)
```

```lua [Client]
local RequestNumber = Riptide.Function(
    "RequestNumber",
    function(Seed)
        return Riptide.Guard.Number(Seed)
    end,
    function(Number)
        return Riptide.Guard.Number(Number)
    end
)
```
:::

This creates a function named `RequestNumber`, with two validation functions - the first one validates arguments, and the second one validates what it returns.

Now, let's expand it to let the client request a random number from the server:

::: code-group
```lua [Server]
local RequestNumber = Riptide.Function(
    "RequestNumber",
    function(Seed)
        return Riptide.Guard.Number(Seed)
    end,
    function(Number)
        return Riptide.Guard.Number(Number)
    end
)

RequestNumber:SetCallback(function(Player, Seed)
    return Random.new(Seed):NextNumber()
end)
```

```lua [Client]
local RequestNumber = Riptide.Function(
    "RequestNumber",
    function(Seed)
        return Riptide.Guard.Number(Seed)
    end,
    function(Number)
        return Riptide.Guard.Number(Number)
    end
)

local RandomNumber = RequestNumber:Call(2^12):Wait() -- `:Call` returns a Future
print(RandomNumber)
```
:::

Running this script should print a random number on the client.

## Unreliable Networking

### Events
Events can be made unreliable by changing the `Reliable` argument in `Event` constructors to `false`:
```lua
local ReplicateInfo = Riptide.Event.Server("Info", false, function(Info)
    return Riptide.Guard.String(Info)
end)
```

### Functions
Riptide doesn't offer unreliable functions.

## Ratelimiting
All events and functions can be ratelimited from the server by utilizing their `:Ratelimit` method.
```lua
Event:Ratelimit(1, 5) -- This event can be called once every 5 seconds
Function:Ratelimit(5, 1) -- This function can be called 5 times every second
```

## Serializing
You can use a serdes library like [Squash](https://data-oriented-house.github.io/Squash/) to lower your bandwith even further.
Serdes is inexpensive and greatly lowers bandwith - you can find measurements of serialized vs deserialized data [here](https://data-oriented-house.github.io/Squash/docs/benchmarks).