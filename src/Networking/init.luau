--!strict
local Net = require(script.Net)
Net.Server.Remotes()

local Event = require(script.Event)
local Function = require(script.Function)
local Identifier = require(script.Identifier)

export type ClientEvent<T...> = Event.Client<T...>
export type ServerEvent<T...> = Event.Server<T...>
export type Function<T..., U...> = Function.Function<T..., U...>

return {
    Net = Net,
    Event = Event,
    Function = Function,
    Identifier = Identifier
}