--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Signal = require(ReplicatedStorage.Packages._Index["red-blox_signal@2.0.2"].signal)
local Ratelimiter = require(ReplicatedStorage.Packages._Index["red-blox_ratelimit@1.0.1"].ratelimit)
local Spawn = require(ReplicatedStorage.Packages._Index["red-blox_spawn@1.0.0"].spawn)

local Net = require(script.Parent.Net)

export type Client<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) -> T...,
    Received: Signal.Signal<T...>,

    Fire: (self: Client<T...>, T...) -> (),
    On: (self: Client<T...>, Callback: (T...) -> ()) -> () -> ()
}

export type Server<T...> = {
    Id: string,
    Reliable: boolean,
    Validate: (...unknown) -> T...,
    Received: Signal.Signal<(Player, T...)>,

    Fire: (self: Server<T...>, Player: Player, T...) -> (),
    FireAll: (self: Server<T...>, T...) -> (),
    FireAllExcept: (self: Server<T...>, Except: Player, T...) -> (),
    FireList: (self: Server<T...>, List: { Player }, T...) -> (),
    FireWithFilter: (self: Server<T...>, Filter: (Player) -> boolean, T...) -> (),

    On: (self: Server<T...>, Callback: (Player, T...) -> ()) -> () -> (),

    Ratelimit: (self: Server<T...>, Limit: number, Interval: number) -> ()
}

--[=[
    A client event.

    @class Client
]=]
local Client = {}
do
    --[=[
        Fires data to the server.

        @within Client
        @param ... -- Args
    ]=]
    local function Fire<T...>(self: Client<T...>, ...: T...)
        if self.Reliable then
            Net.Client.SendReliableEvent(self.Id, table.pack(...))
            return
        end

        Net.Client.SendUnreliableEvent(self.Id, table.pack(...))
    end
    
    --[=[
        Listens to data from the server.

        @within Client
        @param Callback (Args) -> void
        @return () -> () -- Used to disconnect
    ]=]
    local function On<T...>(self: Client<T...>, Callback: (T...) -> ()): () -> ()
        return self.Received:Connect(Callback)
    end

    function Client.new<T...>(Id: string, Reliable: boolean, Validate: (...unknown) -> T...): Client<T...>
        local self = {
            Id = Id,
            Reliable = Reliable,
            Validate = Validate,
            Received = Signal(),

            Fire = Fire,
            On = On
        }
        
        Net.Client.SetListener(self.Id, function(Args)
            self.Received:Fire(table.unpack(Args))
        end)

        return self :: any
    end
end

--[=[
    A server event.

    @class Server
]=]
local Server = {}
do
    local Ratelimits: { [string]: (Key: Player) -> boolean } = {}

    --[=[
        Fires data to the given player.

        @within Server
        @param Player
        @param ... -- Args
    ]=]
    local function Fire<T...>(self: Server<T...>, Player: Player, ...: T...)
        if self.Reliable then
            Net.Server.SendReliableEvent(Player, self.Id, table.pack(...))
            return
        end
    
        Net.Server.SendUnreliableEvent(Player, self.Id, table.pack(...))
    end
    
    --[=[
        Fires data to all players.

        @within Server
        @param ... -- Args
    ]=]
    local function FireAll<T...>(self: Server<T...>, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in Players:GetPlayers() do
            if self.Reliable then
                Net.Server.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            Net.Server.SendUnreliableEvent(Player, self.Id, Args)
        end
    end
    
    --[=[
        Fires data to every player except the given one.

        @within Server
        @param Except Player
        @param ... -- Args
    ]=]
    local function FireAllExcept<T...>(self: Server<T...>, Except: Player, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in Players:GetPlayers() do
            if Player == Except then continue end
    
            if self.Reliable then
                Net.Server.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            Net.Server.SendUnreliableEvent(Player, self.Id, Args)
        end
    end
    
    --[=[
        Fires data to a list of players.

        @within Server
        @param List { Player }
        @param ... -- Args
    ]=]
    local function FireList<T...>(self: Server<T...>, List: { Player }, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in List do
            if self.Reliable then
                Net.Server.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            Net.Server.SendUnreliableEvent(Player, self.Id, Args)
        end
    end
    
    --[=[
        Fires data to filtered players.

        @within Server
        @param Filter (Player) -> boolean
        @param ... -- Args
    ]=]
    local function FireWithFilter<T...>(self: Server<T...>, Filter: (Player) -> boolean, ...: T...)
        local Args = table.pack(...)
    
        for _, Player in Players:GetPlayers() do
            if not Filter(Player) then continue end
    
            if self.Reliable then
                Net.Server.SendReliableEvent(Player, self.Id, Args)
                continue
            end
    
            Net.Server.SendUnreliableEvent(Player, self.Id, Args)
        end
    end

    --[=[
        Listens to data from the client.

        All data from the client is validated first.

        @within Server
        @param Callback (Player, Args) -> void
        @return () -> () -- Used to disconnect
    ]=]
    local function On<T...>(self: Server<T...>, Callback: (Player, T...) -> ()): () -> ()
        return self.Received:Connect(Callback)
    end

    --[=[
        Ratelimits the event.

        @within Server
        @param Limit number
        @param Interval number
    ]=]
    local function Ratelimit<T...>(self: Server<T...>, Limit: number, Interval: number)
        Ratelimits[self.Id] = Ratelimiter(Limit, Interval)
    end

    function Server.new<T...>(Id: string, Reliable: boolean, Validate: (...unknown) -> T...): Server<T...>
        local self = {
            Id = Id,
            Reliable = Reliable,
            Validate = Validate,
            Received = Signal(),

            Fire = Fire,
            FireAll = FireAll,
            FireAllExcept = FireAllExcept,
            FireList = FireList,
            FireWithFilter = FireWithFilter,

            On = On,

            Ratelimit = Ratelimit
        }

        Net.Server.Listen(self.Id, function(Player, Args)
            Spawn(function()
                local Ratelimit = Ratelimits[self.Id]
                if Ratelimit and not Ratelimit(Player) then return end
                if not self.Validate(table.unpack(Args)) then return end

                self.Received:Fire(Player, table.unpack(Args))
            end)
        end)
        
        return self :: any
    end
end

return {
    Client = Client,
    Server = Server
}