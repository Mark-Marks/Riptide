--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Riptide = require(ReplicatedStorage.Packages.Riptide)

local NetTest = {}

function NetTest.Start()
    local Logger = Riptide.Logger.new()
    Logger:OnEvent("Debug", function(Event)
        print(`[🟡][🗼][🕒{Event.Time}]: {Event.Message}`)
    end)

    local ReliableEvent = Riptide.Event.Server("Test", true, function(Number)
        return Riptide.Guard.Number(Number)
    end)

    task.wait(10)
    
    do
        Logger:Debug(`Firing reliable event...`)

        for i = 1, 10 do
            task.wait(.5)
            local Number = math.random(i, 2^12)
            Logger:Debug(`Reliable, expected: {Number}`)
            ReliableEvent:FireAll(Number)
        end

        Logger:Debug(`Finished firing reliable event.`)

        task.wait(5)

        Logger:Debug(`Beginning receiving reliable event...`)

        local Done = Riptide.AnonymousSignal()
        local Count = 1

        local Disconnect = ReliableEvent:On(function(Player, Number)
            Count += 1
            Logger:Debug(`Reliable, player {Player.Name} said {Number}.`)
            if Count < 10 then return end

            Done:Fire()
        end)

        Done:Wait()

        Disconnect()
        Logger:Debug(`Finished receiving reliable event.`)
    end

    task.wait(5)

    do
        local UnreliableEvent = Riptide.Event.Server("Test", false, function(Number)
            return Riptide.Guard.Number(Number)
        end)

        Logger:Debug(`Firing unreliable event...`)

        for i = 1, 10 do
            task.wait(.5)
            local Number = math.random(i, 2^12)
            Logger:Debug(`Unreliable, expected: {Number}`)
            UnreliableEvent:FireAll(Number)
        end

        Logger:Debug(`Finished firing unreliable event.`)

        task.wait(5)

        Logger:Debug(`Beginning receiving unreliable event...`)

        local Done = Riptide.AnonymousSignal()
        local Count = 1

        local Disconnect = UnreliableEvent:On(function(Player, Number)
            Count += 1
            Logger:Debug(`Unreliable, player {Player.Name} said {Number}.`)
            if Count < 10 then return end

            Done:Fire()
        end)

        Done:Wait()

        Disconnect()
        Logger:Debug(`Finished receiving unreliable event.`)
    end
end

return NetTest