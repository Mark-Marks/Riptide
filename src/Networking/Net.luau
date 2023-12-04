--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Guard = require(ReplicatedStorage.Packages._Index["red-blox_guard@1.0.1"].guard)

local Client = {}
do
    local ListenerMap: { [string]: ({ any }) -> () } = {}
    local CallMap: { [string]: thread } = {}
    local Outgoing: {
        Reliable: { [string]: { { any } } },
        Unreliable: { [string]: { { any } } },
        Call: { [string]: { { any } } }
    } = {
        Reliable = {},
        Unreliable = {},
        Call = {}
    }

    function Client.SendReliableEvent(EventId: string, CallList: { any })
        if not Outgoing.Reliable[EventId] then
            Outgoing.Reliable[EventId] = {}
        end

        table.insert(Outgoing.Reliable[EventId], CallList)
    end

    function Client.SendUnreliableEvent(EventId: string, CallList: { any })
        if not Outgoing.Unreliable[EventId] then
            Outgoing.Unreliable[EventId] = {}
        end

        table.insert(Outgoing.Unreliable[EventId], CallList)
    end

    function Client.SetListener(EventId: string, Callback: ({ any }) -> ())
        ListenerMap[EventId] = Callback
    end

    function Client.CallAsync(EventId: string, CallList: { any }): { any }
        if not Outgoing.Call[EventId] then
            Outgoing.Call[EventId] = {}
        end

        table.insert(Outgoing.Call[EventId], CallList)
        CallMap[CallList[1]] = coroutine.running()

        return coroutine.yield()
    end

    function Client.Start()
        local ReliableRemote = ReplicatedStorage:WaitForChild("ReliableRedEvent") :: RemoteEvent
        local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: UnreliableRemoteEvent

        ReliableRemote.OnClientEvent:Connect(function(IncomingFireSection, IncomingCallSection)
            if IncomingFireSection then
                for EventId, CallList in IncomingFireSection do
                    local Listener = ListenerMap[EventId]
                    if not Listener then continue end

                    for _, Call in CallList do
                        Listener(Call)
                    end
                end
            end

            if not IncomingCallSection then return end

            for CallId, CallList in IncomingCallSection do
                local CallThread = CallMap[CallId]
                if not CallThread then continue end

                coroutine.resume(CallThread, table.unpack(CallList))
                CallMap[CallId] = nil
            end
        end)

        UnreliableRemote.OnClientEvent:Connect(function(IncomingFireSection)
            if not IncomingFireSection then return end

            for EventId, CallList in IncomingFireSection do
                local Listener = ListenerMap[EventId]
                if not Listener then continue end

                for _, Call in CallList do
                    Listener(Call)
                end
            end
        end)

        RunService.Heartbeat:Connect(function()
            if next(Outgoing.Reliable) or next(Outgoing.Call) then
                ReliableRemote:FireServer(Outgoing.Reliable, Outgoing.Call)

                Outgoing.Reliable = {}
                Outgoing.Call = {}
            end

            if not next(Outgoing.Unreliable) then return end

            UnreliableRemote:FireServer(Outgoing.Unreliable)

            Outgoing.Unreliable = {}
        end)
    end
end

local Server = {}
do
    local FireSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))
    local CallSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))

    local ListenerMap: { [string]: (Player, { any }) -> () } = {}
    local OutgoingMap: {
        [Player]: {
            Reliable: { [string]: { { any } } },
            Unreliable: { [string]: { { any } } },
            CallReturn: { [string]: { any } }
        }
    } = {}

    function Server.SendReliableEvent(Player: Player, EventId: string, Args: { any })
        if not OutgoingMap[Player] then
            OutgoingMap[Player] = {
                Reliable = {},
                Unreliable = {},
                CallReturn = {}
            }
        end

        if not OutgoingMap[Player].Reliable[EventId] then
            OutgoingMap[Player].Reliable[EventId] = {}
        end

        table.insert(OutgoingMap[Player].Reliable[EventId], Args)
    end

    function Server.SendUnreliableEvent(Player: Player, EventId: string, Args: { any })
        if not OutgoingMap[Player] then
            OutgoingMap[Player] = {
                Reliable = {},
                Unreliable = {},
                CallReturn = {}
            }
        end

        if not OutgoingMap[Player].Unreliable[EventId] then
            OutgoingMap[Player].Unreliable[EventId] = {}
        end

        table.insert(OutgoingMap[Player].Unreliable[EventId], Args)
    end

    function Server.Listen(EventId: string, Callback: (Player, { any }) -> ())
        ListenerMap[EventId] = Callback
    end

    function Server.SendCallReturn(Player: Player, CallId: string, Args: { any })
        if not OutgoingMap[Player] then
            OutgoingMap[Player] = {
                Reliable = {},
                Unreliable = {},
                CallReturn = {}
            }
        end

        OutgoingMap[Player].CallReturn[CallId] = Args
    end

    function Server.Start()
        local ReliableRemote = ReplicatedStorage:WaitForChild("ReliableRedEvent") :: RemoteEvent
        local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: UnreliableRemoteEvent

        ReliableRemote.OnServerEvent:Connect(function(Player, IncomingFireSection, IncomingCallSection)
            local FireSectionValid, FireSection = FireSectionCheck(IncomingFireSection)

            if FireSectionValid then
                for EventId, CallList in FireSection do
                    local Listener = ListenerMap[EventId]
                    if not Listener then return end

                    for _, Call in CallList do
                        Listener(Player, Call)
                    end
                end
            end

            local CallSectionValid, CallSection = CallSectionCheck(IncomingCallSection)
            if not CallSectionValid then return end

            for EventId, CallList in CallSection do
                local Listener = ListenerMap[EventId]

                if Listener then
                    for _, Call in CallList do
                        Listener(Player, Call)
                    end
                    continue
                end

                for _, Call in CallList do
                    local CallId = Call[1]

                    Server.SendCallReturn(Player, CallId, { false, "Event has no listener." })
                end
            end
        end)

        UnreliableRemote.OnServerEvent:Connect(function(Player, IncomingFireSection)
            local FireSectionValid, FireSection = FireSectionCheck(IncomingFireSection)
            if not FireSectionValid then return end

            for EventId, CallList in FireSection do
                local Callback = ListenerMap[EventId]
                if not Callback then continue end

                for _, Call in CallList do
                    Callback(Player, Call)
                end
            end
        end)

        RunService.Heartbeat:Connect(function()
            for Player, Outgoing in OutgoingMap do
                if next(Outgoing.Reliable) or next(Outgoing.CallReturn) then
                    ReliableRemote:FireClient(Player, Outgoing.Reliable, Outgoing.CallReturn)
                end

                if next(Outgoing.Unreliable) then
                    UnreliableRemote:FireClient(Player, Outgoing.Unreliable)
                end

                OutgoingMap[Player] = nil
            end
        end)
    end

    --[=[
        Creates Red remotes.

        @private
    ]=]
    function Server.Remotes()
        if not RunService:IsServer() then return end

        if not ReplicatedStorage:FindFirstChild("ReliableRedEvent") then
            local ReliableRemote = Instance.new("RemoteEvent")
            ReliableRemote.Name = "ReliableRedEvent"
            ReliableRemote.Parent = ReplicatedStorage
        end

        if not ReplicatedStorage:FindFirstChild("UnreliableRedEvent") then
            local UnreliableRemote = Instance.new("UnreliableRemoteEvent")
            UnreliableRemote.Name = "UnreliableRedEvent"
            UnreliableRemote.Parent = ReplicatedStorage
        end

        if not ReplicatedStorage:FindFirstChild("RedEvent") then
            local RedEvent = Instance.new("RemoteEvent")
            RedEvent.Name = "RedEvent"
            RedEvent.Parent = ReplicatedStorage
        end
    end
end

return {
    Client = Client,
    Server = Server
}