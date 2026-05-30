local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local InventoryServer = require(ServerScriptService.Features.Inventory.InventoryServer)
local networker = require(ReplicatedStorage.Packages.networker)
local RebirthRequirements = require(ReplicatedStorage.Shared.Features.Rebirth.Modules.RebirthRequirements)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local rebirthServer = {}

function rebirthServer.init(self:rebirthServer)
    self.networker = networker.server.new("rebirthFeature", self, {self.attemptRebirth})
end

function rebirthServer.attemptRebirth(_self:rebirthServer, player:Player)
    local playerData = dataservice:get(player) :: DataTemplate.data

    local nextRebirth = playerData.Rebirth + 1

    if not RebirthRequirements[nextRebirth] then return end

    local meetsReqs = true
    for _, requirement in RebirthRequirements[nextRebirth] do
        if requirement.Type == "Tower" then
            local hasItem = InventoryServer:hasItem(player, requirement.Params)
            if not hasItem then
                meetsReqs = false
            end
        elseif requirement.Type == "Cash" then
            if playerData.Cash < requirement.Params then
                meetsReqs = false
            end
        end
    end

    if not meetsReqs then return end

    dataservice:update(player, {"Rebirth"}, function(val)
        return val + 1
    end)
    dataservice:set(player, {"Cash"}, 0)
end

type rebirthServer = typeof(rebirthServer)

return rebirthServer :: rebirthServer