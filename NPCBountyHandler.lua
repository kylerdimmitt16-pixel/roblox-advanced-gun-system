-- NPCBountyHandler.lua
-- Place this Script in ServerScriptService
-- This script gives bounty for NPC hit and kill events.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = require(ReplicatedStorage:WaitForChild("GunConfig"))

local bountyEvent = ReplicatedStorage:FindFirstChild("NpcBountyEvent")
if not bountyEvent then
    bountyEvent = Instance.new("RemoteEvent")
    bountyEvent.Name = "NpcBountyEvent"
    bountyEvent.Parent = ReplicatedStorage
end

local function addBounty(player, amount)
    if not player then return end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end

    local bountyValue = leaderstats:FindFirstChild("Bounty")
    if not bountyValue then
        bountyValue = Instance.new("IntValue")
        bountyValue.Name = "Bounty"
        bountyValue.Value = 0
        bountyValue.Parent = leaderstats
    end

    bountyValue.Value += amount
end

bountyEvent.OnServerEvent:Connect(function(player, hitHumanoid, wasKill)
    if not player or not hitHumanoid then return end

    if wasKill then
        addBounty(player, config.NPCKillBounty)
    else
        addBounty(player, config.NPCDamageBounty)
    end
end)
