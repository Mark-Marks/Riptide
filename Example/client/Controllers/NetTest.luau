--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Riptide = require(ReplicatedStorage.Packages.Riptide)

local NetTest = {}

function NetTest.Start()
    local Logger = Riptide.Logger.new()
    Logger:OnEvent("Debug", function(Event)
        print(`[🟡][🖥️][🕒{Event.Time}]: {Event.Message}`)
    end)

    do
        local ReliableEvent = Riptide.Event.Client("Test", true, function(Number)
            return Riptide.Guard.Number(Number)
        end)

        Logger:Debug(`Receiving reliable event...`)

        local Done = Riptide.AnonymousSignal()
        local Count = 1

        local Disconnect = ReliableEvent:On(function(Number)
            Count += 1
            Logger:Debug(`Reliable, server said {Number}.`)
            if Count < 10 then return end

            Done:Fire()
        end)

        Done:Wait()
        Logger:Debug(`Finished receiving reliable event.`)
        Disconnect()

        task.wait(5)

        Logger:Debug(`Firing reliable event...`)

        for i = 1, 10 do
            task.wait(.5)
            local Number = math.random(i, 2^12)
            Logger:Debug(`Reliable, expected: {Number}`)
            ReliableEvent:Fire(Number)
        end

        Logger:Debug(`Finished firing reliable event.`)
    end

    task.wait(5)

    do
        local UnreliableEvent = Riptide.Event.Client("Test", false, function(Number)
            return Riptide.Guard.Number(Number)
        end)

        Logger:Debug(`Receiving unreliable event...`)

        local Done = Riptide.AnonymousSignal()
        local Count = 1

        local Disconnect = UnreliableEvent:On(function(Number)
            Count += 1
            Logger:Debug(`Unreliable, server said {Number}.`)
            if Count < 10 then return end

            Done:Fire()
        end)

        Done:Wait()
        Logger:Debug(`Finished receiving unreliable event.`)
        Disconnect()

        task.wait(5)

        Logger:Debug(`Firing unreliable event...`)

        for i = 1, 10 do
            task.wait(.5)
            local Number = math.random(i, 2^12)
            Logger:Debug(`Unreliable, expected: {Number}`)
            UnreliableEvent:Fire(Number)
        end

        Logger:Debug(`Finished firing unreliable event.`)
    end
end

return NetTest