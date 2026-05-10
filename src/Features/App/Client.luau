local GroupService = game:GetService("GroupService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local BoostServiceClient = require(ReplicatedStorage.Shared.Modular.Services.BoostService.BoostServiceClient)

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local networker = require(ReplicatedStorage.Packages.networker)
local vide = require(ReplicatedStorage.Packages.vide)
local FunnelServiceClient = require(ReplicatedStorage.Shared.Modular.Services.FunnelService.FunnelServiceClient)
local client = {}

local potionSources: {[string]: vide.Source<number>} = {
    Cash = AppSlice.cashPotionTime,
    Speed = AppSlice.speedPotionTime,
    Wins = AppSlice.winsPotionTime,
}

function client.setPotionTime(_self:client, boost:string, time:number)
    local s = potionSources[boost]
    if s then
        s(time)
    end
end

function client.setGroupRewardCooldown(_self:client, time:number)
    AppSlice.groupRewardCooldown(time)
end

function client.promptJoinGroup(_self:client)
    GroupService:PromptJoinAsync(AppConstants.GROUPID)
end

function client.init(self:client)
    self.networker = networker.client.new("appFeature", self)

    AppSlice.cashAmount(dataservice:get({"Cash"}))
    AppSlice.winsAmount(dataservice:get({"Wins"}))
    dataservice:getChangedSignal({"Cash"}):Connect(function(val)
        AppSlice.cashAmount(val)
    end)
    dataservice:getChangedSignal({"Wins"}):Connect(function(val)
        AppSlice.winsAmount(val)
    end)

    for boost, source in potionSources do
        source(BoostServiceClient:getTimedBoost(boost, "Potion"))
    end

    AppSlice.groupRewardCooldown(self.networker:fetch("getGroupRewardCooldown"))

    AppSlice.requestGroupReward:Connect(function()
        self.networker:fire("requestGroupReward")
    end)

    task.spawn(function()
        while task.wait(1) do
            for _, source in potionSources do
                source(math.max(source() - 1, 0))
            end
            AppSlice.groupRewardCooldown(math.max(AppSlice.groupRewardCooldown() - 1, 0))
        end
    end)

    FunnelServiceClient:stepCompleted(AppConstants.FUNNELS.PURCHASE_SPIN, 1, "Joined")
end

type client = typeof(client)

return client :: client
