local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local server = {}

function server.init(self:server)
    self.networker = networker.server.new("Monitization", self, {self.updateExtraInfo})

    self.ids = {} :: {
        [string]: {[number]:any}
    }

    self.signals = {} :: {
        [string]: signal.Signal<>,
    }

    self.extraInfos = {} :: {
        [number]: any?,
    }

    MarketplaceService.ProcessReceipt = function(info)
        return self:processReceipt(info)
    end
end

function server.playerAdded(_self:server, _player:Player, data)
    if not data.MonitizationData then
        data.MonitizationData = {
            FirstLogin = os.time(),
            TimeUntilFirstPurchase = 10e10,
            TotalRobuxSpent = 0,
            PurchaseHistory = {},
        }
    end
end

function server.processReceipt(self:server, info)
    local productId = info.ProductId
    local cost = info.CurrencySpent
    local player = Players:GetPlayerByUserId(info.PlayerId)

    local data = dataservice:get(player, {"MonitizationData"})

    if data.TotalRobuxSpent == 0 then
        dataservice:set(player, "TimeUntilFirstPurchase", os.time() - data.FirstLogin) 
    end

    dataservice:update(player, {"MonitizationData", "TotalRobuxSpent"}, function(preVal)
        return preVal + cost
    end)

    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    for branch: string, ids in self.ids do
        for id, tbl in ids do
            if id == productId then
                self.signals[branch]:Fire(player, tbl, self.extraInfos[player.UserId])
                return Enum.ProductPurchaseDecision.PurchaseGranted
            end
        end
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

function server.updateExtraInfo(self:server, player:Player, extraInfo:any)
    self.extraInfos[player.UserId] = extraInfo
end

--[[
    Assigns every productId a table when purchased, and returns a signal for when something within your branch is purchased.
    ```lua
    Eg = {
        [2947233598] = {
            Coins = 500,
        }
    }
    ```
]]
function server.registerIds(self:server, branch:string, ids: {[number]:any})
    self.ids[branch] = ids

    local branchSignal = signal.new()

    self.signals[branch] = branchSignal

    return branchSignal
end

type server = typeof(server)

return server :: server