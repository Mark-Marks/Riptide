--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Riptide = require(ReplicatedStorage.Packages.Riptide)

Riptide.AddSingletons(StarterPlayer.StarterPlayerScripts.Controllers)

Riptide.Ignite():After(function(Took)
    Riptide.DefaultLogger:Info(`Loaded riptide. Took {Took}s.`)
end)
