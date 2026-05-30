local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local InventoryServer = require(ServerScriptService.Features.Inventory.InventoryServer)
local PlotClassServer = require(ServerScriptService.Features.Plot.Classes.Plots.PlotClassServer)
local BoostServiceServer = require(ServerScriptService.Modular.Services.BoostService.BoostServiceServer)
local ItemServiceServer = require(ServerScriptService.Modular.Services.ItemService.ItemServiceServer)
local LuckServiceServer = require(ServerScriptService.Modular.Services.LuckService.LuckServiceServer)
local MonitizationServiceServer = require(ServerScriptService.Modular.Services.MonitizationService.MonitizationServiceServer)
local networker = require(ReplicatedStorage.Packages.networker)
local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local SkipWaitTimes = require(ReplicatedStorage.Shared.Features.Plot.Modules.SkipWaitTimes)
local StandRequirements = require(ReplicatedStorage.Shared.Features.Plot.Modules.StandRequirements)
local Sync = require(ReplicatedStorage.Shared.Features.Plot.Modules.Sync)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local getUnusedIndex = require(ReplicatedStorage.Shared.Modular.Math.getUnusedIndex)
local plotServer = {}

local plotCFrames = game.Workspace.PlotCFrames :: Folder

function plotServer.init(self:plotServer)
    self.networker = networker.server.new("plotFeature", self, {
        self.attemptPlace,
        self.attemptRemove,
        self.attemptOpen,
        self.attemptPurchaseCrate,
        self.attemptSkipCrate,
        self.attemptUnlockStand,
        })

    Sync:init()

    self.plots = {} :: {
        [number]: PlotClassServer.plotClass
    }

    self.playerConnections = {} :: {
        [number]: {RBXScriptConnection}
    }

    for _, plotCFrame:Part in plotCFrames:GetChildren() do
        local index = tonumber(plotCFrame.Name)
        self.plots[index] = PlotClassServer.new {
            Index = index,
        }
    end

    ItemServiceServer:registerItemFunction("Crate", function(player: Player, params:{Name:string, Time:number?})
        local index = getUnusedIndex(dataservice:get(player, {"Inventory"}))
        local crateInfo = Crates[params.Name]
        local tbl = {
            Type = "Crate",
            Name = params.Name,
            Time = params.Time or crateInfo.Time
        }
        dataservice:set(player, {"Inventory", index}, tbl)
    end)

    ItemServiceServer:registerItemFunction("Tower", function(player: Player, params:{Name:string})
        local index = getUnusedIndex(dataservice:get(player, {"Inventory"}))
        local tbl = {
            Type = "Tower",
            Name = params.Name,
            Cash = params.Cash or 0
        }
        dataservice:set(player, {"Inventory", index}, tbl)
    end)


    local ids = {}

    for name, info in Crates do
        if info.ProductId then
            ids[info.ProductId] = {
                Type = "Item",
                Item = "Crate", 
                Params = {
                    Name = name,
                    Type = "Crate"
                }
            }
        end
    end

    for _, info in SkipWaitTimes do
        ids[info.ProductId] = {
            Type = "Skip Wait",
        }
    end

    MonitizationServiceServer:registerIds("plotFeature", ids):Connect(function(player, rewardInfo, extraInfo)
        if rewardInfo.Type == "Item" then
            ItemServiceServer:giveItem(player, rewardInfo.Item, rewardInfo.Params)
            dataservice:set(player, {"CurrentCrate"}, nil)
            self.networker:fire(player, "removeConveyerCrate")
        elseif rewardInfo.Type == "Skip Wait" then
            local standInfo = dataservice:get(player, {"Stands", extraInfo.Stand}) :: DataTemplate.StandInfo
            self:open(player, standInfo, extraInfo.Stand)
        end
    end)
end

function plotServer.playerAdded(self:plotServer, player:Player, data:DataTemplate.data)
    local plot = self:findUnclaimedPlot()
    plot:claim(player, data)

    self.playerConnections[player.UserId] = {}

    self.networker:fire(player, "claim", plot:getIndex(), Sync.startTime, Sync.tick)
    for _, newPlot in self.plots do
        if newPlot:getOwner() ~= player and newPlot:getOwner() ~= nil then
            local plotData = dataservice:get(newPlot:getOwner())
            self.networker:fire(player, "NPClaim", newPlot:getIndex(), plotData)
        end
    end
    self.networker:fireAllExcept(player, "NPClaim", plot:getIndex(), data)

    local conveyerUpgradeConnection = dataservice:getChangedSignal(player, {"Upgrades", "Conveyer"}):Connect(function(level:number)
        self.networker:fire(player, "upgradeConveyer", level)
        self.networker:fireAllExcept(player, "NPUpgradeConveyer", plot:getIndex(), level)
    end)

    table.insert(self.playerConnections[player.UserId], conveyerUpgradeConnection)
end

function plotServer.playerRemoved(self:plotServer, player:Player, _data:DataTemplate.data)
    local plot = self:getPlayerPlot(player)
    plot:unclaim()
    self.networker:fireAllExcept(player, "NPUnclaim", plot:getIndex())

    for _, connection in self.playerConnections[player.UserId] do
        connection:Disconnect()
    end
    self.playerConnections[player.UserId] = nil 
end

function plotServer.attemptPurchaseCrate(_self:plotServer, player:Player)
    local crateInfo = dataservice:get(player, {"CurrentCrate"}) :: DataTemplate.CrateInfo
    local cost = Crates[crateInfo.Name].Cost
    if dataservice:get(player, {"Cash"}) >= cost then
        dataservice:update(player, {"Cash"}, function(val)
            return val - cost
        end)
        ItemServiceServer:giveItem(player, "Crate", crateInfo)
        dataservice:set(player, {"CurrentCrate"}, nil)
        return true
    else
        return false
    end
end

function plotServer.attemptSkipCrate(_self:plotServer, player:Player)
    local playerLuck = BoostServiceServer:getBoost(player, "Luck")
    local crateName = LuckServiceServer:getWeightedRandom(Crates, playerLuck)

    local crateInfo = {
        Name = crateName,
        Type = "Crate",
    }

    dataservice:set(player, {"CurrentCrate"}, crateInfo)

    return crateInfo
end

function plotServer.attemptUnlockStand(self:plotServer, player:Player)
    local playerData = dataservice:get(player) :: DataTemplate.data
    local nextStand = #playerData.Stands + 1

    if not StandRequirements[nextStand] then return end
    if playerData.Cash < StandRequirements[nextStand][1] then return end
    if playerData.Rebirth < StandRequirements[nextStand][2] then return end

    dataservice:update(player, {"Cash"}, function(val:number)
        return val - StandRequirements[nextStand][1]
    end)

    local plot = self:getPlayerPlot(player)
    
    local standInfo = {
        Type = "Empty"
    }
    self:place(player, nextStand, standInfo)

    self.networker:fire(player, "unlockStand", nextStand)
    self.networker:fireAllExcept(player, "NPUnlockStand",plot:getIndex(), nextStand)
end

function plotServer.attemptPlace(self:plotServer, player:Player, stand:number)
    local standInfo = dataservice:get(player, {"Stands", stand}) :: DataTemplate.StandInfo
    if not standInfo then return end

    if standInfo.Type ~= "Empty" then
        local index = getUnusedIndex(dataservice:get(player, {"Inventory"}))
        dataservice:set(player, {"Inventory", index}, standInfo)
        self:remove(player,stand)
    end

    local itemInfo, index = InventoryServer:getHeldInfo(player)
    if itemInfo then
        dataservice:set(player, {"Inventory", index}, nil)
        self:place(player, stand, itemInfo)
    end
end

function plotServer.attemptOpen(self:plotServer, player:Player, stand:number)
    local standInfo = dataservice:get(player, {"Stands", stand}) :: DataTemplate.StandInfo
    if not standInfo then return end

    if standInfo.Type == "Crate" and standInfo.Time == 0 then
        self:open(player, standInfo, stand)
    end
end

function plotServer.attemptRemove(self:plotServer, player:Player, stand:number)
    local standInfo = dataservice:get(player, {"Stands", stand}) :: DataTemplate.StandInfo
    if not standInfo then return end

    if standInfo.Type ~= "Empty" then
        local index = getUnusedIndex(dataservice:get(player, {"Inventory"}))
        dataservice:set(player, {"Inventory", index}, standInfo)
        self:remove(player, stand)
    end
end

function plotServer.open(self:plotServer, player:Player, standInfo:DataTemplate.StandInfo, stand:number)
    local playerLuck = BoostServiceServer:getBoost(player, "Luck")
    local crateInfo = Crates[standInfo.Name]
    
    local tower = crateInfo.Tower
    if not tower then
        tower = LuckServiceServer:getWeightedRandom(crateInfo.Towers, playerLuck)
    end

    local itemInfo = {
        Type = "Tower",
        Name = tower,
    }

    self:remove(player, stand)
    self:place(player, stand, itemInfo)
end

function plotServer.place(self:plotServer, player:Player, stand:number, itemInfo)
    dataservice:set(player, {"Stands", stand}, itemInfo)
    local plot = self:getPlayerPlot(player)
    plot:place(stand, itemInfo)
    self.networker:fire(player, "place", stand, itemInfo)
    self.networker:fireAllExcept(player, "NPPlace", plot:getIndex(), stand, itemInfo)
end

function plotServer.remove(self:plotServer, player:Player, stand:number)
    dataservice:set(player, {"Stands", stand}, {
        Type = "Empty"
    })
    local plot = self:getPlayerPlot(player)
    plot:remove(stand)
    self.networker:fire(player, "remove", stand)
    self.networker:fireAllExcept(player, "NPRemove", plot:getIndex(), stand)
end

function plotServer.getPlayerPlot(self:plotServer, player:Player)
    for _, plot in self.plots do
        if plot:getOwner() == player then
            return plot 
        end
    end
    return nil
end

function plotServer.findUnclaimedPlot(self:plotServer)
    for _, plot in self.plots do
        if plot:getOwner() == nil then
            return plot
        end
    end
    return nil
end 

type plotServer = typeof(plotServer)

return plotServer :: plotServer