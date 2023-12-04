--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Future = require(ReplicatedStorage.Packages._Index["red-blox_future@1.0.1"].future)
local Spawn = require(ReplicatedStorage.Packages._Index["red-blox_spawn@1.0.0"].spawn)
local Ratelimiter = require(ReplicatedStorage.Packages._Index["red-blox_ratelimit@1.0.1"].ratelimit)

local Net = require(script.Parent.Net)
local DefaultLogger = require(script.Parent.Parent.Logger).Default
local Identifier = require(script.Parent.Identifier)

export type Function<T..., U...> = {
    Id: string,
    Validate: (...unknown) -> T...,

    SetCallback: (self: Function<T..., U...>, Callback: (Player, T...) -> U...) -> () -> (),
    Call: (self: Function<T..., U...>, T...) -> Future.Future<(boolean, U...)>,
    RateLimit: (self: Function<T..., U...>, Limit: number, Interval: number) -> ()
}

--[=[
    A blazingly fast remote function.

    Server side example
    ```lua
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

    Client side example
    ```lua
    local GetMoney = Riptide.Function(
        "GetMoney",
        function() end,
        function(Money)
            return Riptide.Guard.Number(Money) -- Types the return as a Number
        end
    )

    local Money = GetMoney:Call():Await()
    ```

    @class Function
]=]
local Function = {}

local Ratelimits: { [string]: (Key: Player) -> boolean } = {}

--[=[
    Sets the callback of the remote function.

    ⚠️ Only callable on the server!

    @within Function
    @param Callback (Player, Args) -> Return
]=]
local function SetCallback<T..., U...>(self: Function<T..., U...>, Callback: (Player, T...) -> U...)
    DefaultLogger:FatalAssert(RunService:IsServer(), "[Riptide] Function.SetCallback: Cannot set callback to function on client.")

    Net.Server.Listen(self.Id, function(Player, Args)
        local CallId = table.remove(Args, 1)
        if typeof(CallId) ~= "string" then return end

        Spawn(function(EventId: string, Player: Player, CallId: string, ...: any)
            local Ratelimit = Ratelimits[EventId]
            if Ratelimit and not Ratelimit(Player) then return end
            if not pcall(self.Validate, ...) then return end

            Net.Server.SendCallReturn(Player, CallId, table.pack(pcall(Callback,Player, ...)))
        end, self.Id, Player, CallId, table.unpack(Args))
    end)
end

--[=[
    Calls the remote function.

    ⚠️ Only callable on the client!

    @within Function
    @param ... -- Args
]=]
local function Call<T..., U...>(self: Function<T..., U...>, ...: T...)
    DefaultLogger:FatalAssert(RunService:IsClient(), "[Riptide] Function.Call: Cannot call on the server.")

    return Future.new(function(...: T...)
        local CallId = Identifier.Unique()

        return table.unpack(Net.Client.CallAsync(self.Id, table.pack(CallId, ...)))
    end, ...)
end

--[=[
    Ratelimits the function.

    @within Function
    @param Limit number
    @param Interval number
]=]
local function Ratelimit<T..., U...>(self: Function<T..., U...>, Limit: number, Interval: number)
    DefaultLogger:FatalAssert(RunService:IsServer(), "[Riptide] Function.Ratelimit: Cannot call on the client.")

    Ratelimits[self.Id] = Ratelimiter(Limit, Interval)
end

function Function.new<T..., U...>(Name: string, ValidateArgs: (...unknown) -> T..., ValidateReturn: (...unknown) -> U...): Function<T..., U...>
    DefaultLogger:FatalAssert(not Identifier.Exists(Name), "[Riptide] Function.new: Cannot use the same name twice.")

    return {
        Id = Identifier.Shared(Name):Await(),
        Validate = ValidateArgs,

        SetCallback = SetCallback,
        Call = Call,
        Ratelimit = Ratelimit
    } :: any
end

return Function