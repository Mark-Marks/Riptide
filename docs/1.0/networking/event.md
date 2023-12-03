# Event
Blazingly fast & typesafe networking, utilizing [Red](https://red.redblox.dev) under the hood.
::: code-group
```lua [Server]
local ValidateRole = Riptide.Guard.Or(Riptide.Guard.Literal("Murderer"), Riptide.Guard.Literal("Innocent"))
local AssignRole = Riptide.Event.Server("AssignRole", true, function(Role)
    return ValidateRole(Role) -- Automatically types `Team` as `"Murderer" | "Innocent"`
end)

AssignRole:Fire(Murderer, "Murderer")
```

```lua [Client]
local ValidateRole = Riptide.Guard.Or(Riptide.Guard.Literal("Murderer"), Riptide.Guard.Literal("Innocent"))
local AssignRole = Riptide.Event.Client("AssignRole", true, function(Role)
    return ValidateRole(Role) -- Automatically types `Team` as `"Murderer" | "Innocent"`
end)

AssignRole:On(function(Role) -- `Role` is now `"Murder" | "Innocent"`
    LocalPlayer.Role.Value = Role
end)
```
:::

## Functions

### Client
```lua
Event.Client<T...>(
    Name: string,
    Reliable: boolean,
    Validate: (...unknown) → T... -- Purely for typechecking, doesn't actually do anything
) → ClientEvent
```
Constructs a [client event](/1.0/networking/clientevent).

### Server
```lua
Event.Server<T...>(
    Name: string,
    Reliable: boolean,
    Validate: (...unknown) → T... -- Sanity checks the data sent from the player & provides typechecking
) → ServerEvent
```
Constructs a [server event](/1.0/networking/serverevent).