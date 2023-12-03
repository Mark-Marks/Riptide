--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Riptide = require(ReplicatedStorage.Packages.Riptide)

Riptide.AddSingletons(ServerScriptService.Services)

Riptide.Ignite():After(function(Took)
    Riptide.DefaultLogger:Info(`Loaded riptide. Took {Took}s.`)
end)
