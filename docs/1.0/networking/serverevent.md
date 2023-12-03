# ServerEvent
A server event. Constructed by [Event](/1.0/networking/event).

## Methods

### Fire
```lua
ServerEvent.Fire<T...>(
    self: ServerEvent<T...>,
    Player: Player,
    ...: T... -- Args
) → ()
```
Fires data to the specified player.

### FireAll
```lua
ServerEvent.FireAll<T...>(
    self: ServerEvent<T...>,
    ...: T... -- Args
) → ()
```
Fires data to all players.

### FireAllExcept
```lua
ServerEvent.FireAllExcept<T...>(
    self: ServerEvent<T...>,
    Except: Player,
    ...: T... -- Args
) → ()
```
Fires data to every player except the specified one.

### FireList
```lua
ServerEvent.FireList<T...>(
    self: ServerEvent<T...>,
    List: { Player },
    ...: T... -- Args
) → ()
```
Fires data to a list of players.

### FireWithFilter
```lua
ServerEvent.FireWithFilter<T...>(
    self: ServerEvent<T...>,
    Filter: (Player) → boolean,
    ...: T... -- Args
) → ()
```
Fires data to filtered players.

### On
```lua
ServerEvent.On<T...>(
    self: ServerEvent<T...>,
    Callback: (
        Player,
        Args
    ) → void
) → () → () -- Used to disconnect 
```
Listens to data from the client.
All data from the client is validated first.

### Ratelimit
```lua
ServerEvent.Ratelimit<T...>(
    self: ServerEvent<T...>,
    Limit: number,
    Interval: number
) → ()
```
Ratelimits the event.