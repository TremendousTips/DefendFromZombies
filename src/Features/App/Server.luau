local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local BoostServiceServer = require(ServerScriptService.Modular.Services.BoostService.BoostServiceServer)
local FunnelServiceServer = require(ServerScriptService.Modular.Services.FunnelService.FunnelServiceServer)
local ItemServiceServer = require(ServerScriptService.Modular.Services.ItemService.ItemServiceServer)
local MonitizationServiceServer = require(ServerScriptService.Modular.Services.MonitizationService.MonitizationServiceServer)
local networker = require(ReplicatedStorage.Packages.networker)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local AppProductIds = require(ReplicatedStorage.Shared.Features.App.Modules.AppProductIds)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)

local dataservice = require(ReplicatedStorage.Packages.dataservice).server

local server = {}

function server.init(self:server)
    self.networker = networker.server.new("appFeature", self, {self.requestGroupReward, self.getGroupRewardCooldown})

    local ids = {}

    for _, v in AppProductIds do
        ids[v.ProductId] = {
            Type = v.Type,
            Params = v.Params
        }
    end

    ItemServiceServer:registerItemFunction("Boost", function(player: Player, params)
        BoostServiceServer:addBoost(player, params.Name, "Potion", 100, params.Time)
        local boostTime = BoostServiceServer:getTimedBoost(player, params.Name, "Potion")
        self.networker:fire(player, "setPotionTime", params.Name, boostTime)
    end)

    ItemServiceServer:registerItemFunction("Pack", function(player: Player, params)  
        for _, item in params do
            ItemServiceServer:giveItem(player, item.Type, item.Params)
        end
    end)

    MonitizationServiceServer:registerIds("app", ids):Connect(function(player:Player, info)
        ItemServiceServer:giveItem(player, info.Type, info.Params)
    end)

    FunnelServiceServer:validateStep(AppConstants.FUNNELS.PURCHASE_SPIN, 1, "Joined")
    FunnelServiceServer:validateStep(AppConstants.FUNNELS.PURCHASE_SPIN, 2, "Opened Menu")
    FunnelServiceServer:validateStep(AppConstants.FUNNELS.PURCHASE_SPIN, 3, "Prompted")
    FunnelServiceServer:validateStep(AppConstants.FUNNELS.PURCHASE_SPIN, 4, "Purchased")
end

function server.playerAdded(_self:server, _player:Player, data:DataTemplate.data)
    if data.GroupRewardLastClaim == 0 then
        data.GroupRewardLastClaim = os.time()
    end
end

function server.getGroupRewardCooldown(_self:server, player:Player)
    local data = dataservice:get(player) :: DataTemplate.data
    return math.max((data.GroupRewardLastClaim + AppConstants.GROUP_REWARD_COOLDOWN) - os.time(), 0)
end

function server.requestGroupReward(self:server, player:Player)
    local cooldown = self:getGroupRewardCooldown(player)
    if cooldown > 0 then
        self.networker:fire(player, "setGroupRewardCooldown", cooldown)
        return
    end

    if not player:IsInGroupAsync(AppConstants.GROUPID) then
        self.networker:fire(player, "promptJoinGroup")
        return
    end

    ItemServiceServer:giveItem(player, "Cash", AppConstants.GROUP_REWARD_CASH)
    dataservice:set(player, {"GroupRewardLastClaim"}, os.time())
    self.networker:fire(player, "setGroupRewardCooldown", AppConstants.GROUP_REWARD_COOLDOWN)
end

type server = typeof(server)

return server :: server
