# ClientEvent
A client event. Constructed by [Event](/1.0/networking/event).

## Methods

### Fire
```lua
ClientEvent.Fire<T...>(
    self: ClientEvent<T...>,
    ...: T... -- Args
) → ()
```
Fires data to the server.

### On
```lua
ClientEvent.On<T...>(
    self: ClientEvent<T...>,
    Callback: (Args) → void
) → () → () -- Used to disconnect
```
Listens to data from the server.