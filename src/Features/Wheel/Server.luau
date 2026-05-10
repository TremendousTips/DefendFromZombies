local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local ItemServiceServer = require(ServerScriptService.Modular.Services.ItemService.ItemServiceServer)
local LuckServiceServer = require(ServerScriptService.Modular.Services.LuckService.LuckServiceServer)
local MonitizationServiceServer = require(ServerScriptService.Modular.Services.MonitizationService.MonitizationServiceServer)
local networker = require(ReplicatedStorage.Packages.networker)
local WheelInfo = require(ReplicatedStorage.Shared.Features.Wheel.Modules.WheelInfo)
local WheelProductIds = require(ReplicatedStorage.Shared.Features.Wheel.Modules.WheelProductIds)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local server = {}

function server.init(self:server)
    self.networker = networker.server.new("wheelFeature", self, {self.requestSpin})

    local ids = {}

    for _, info in WheelProductIds do
        ids[info.ProductId] = info.Reward
    end

    ItemServiceServer:registerItemFunction("Spins", function(player: Player, amount:number)  
        dataservice:update(player, {"Spins"}, function(preVal:number)  
            return preVal + amount
        end)
    end)

    MonitizationServiceServer:registerIds("wheelFeature", ids):Connect(function(player:Player, reward)  
        self.networker:fire(player, "boughtSpin")
        ItemServiceServer:giveItem(player, reward.Type, reward.Params)
    end)
end

function server.requestSpin(_self:server, player:Player)
    local playerData = dataservice:get(player) :: DataTemplate.data
    if playerData.Spins > 0 then
        dataservice:update(player, {"Spins"}, function(preVal)  
            return preVal - 1
        end)
        local index = LuckServiceServer:getWeightedRandom(WheelInfo, 100)
        local reward = WheelInfo[index].Reward
        ItemServiceServer:giveItem(player, reward.Type, reward.Params)
        return index
    else
        return nil
    end
end

type server = typeof(server)

return server :: server