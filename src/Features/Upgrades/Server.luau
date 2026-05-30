local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local networker = require(ReplicatedStorage.Packages.networker)
local UpgradeCosts = require(ReplicatedStorage.Shared.Features.Upgrades.Modules.UpgradeCosts)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local upgradesServer = {}

function upgradesServer.init(self:upgradesServer)
    self.networker = networker.server.new("upgradesFeature", self, {self.requestUpgrade})

end

function upgradesServer.requestUpgrade(_self:upgradesServer, player:Player, upgrade:string)
    local playerData = dataservice:get(player) :: DataTemplate.data
    local nextUpgrade = playerData.Upgrades[upgrade]+1
    if not UpgradeCosts[upgrade][nextUpgrade] then return false end

    local cost = UpgradeCosts[upgrade][nextUpgrade]

    if playerData.Cash >= cost then
        
        dataservice:update(player, {"Cash"}, function(val)
            return val - cost
        end)
        dataservice:update(player, {"Upgrades", upgrade}, function(val)
            return val + 1
        end)
        return true
    else
        return false
    end
end

type upgradesServer = typeof(upgradesServer)

return upgradesServer :: upgradesServer