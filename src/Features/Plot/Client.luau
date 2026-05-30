local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local PlotSlice = require(script.Parent.PlotSlice)
local PlotUtils = require(script.Parent.PlotUtils)
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local NotPlayersPlotClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Plots.NotPlayersPlotClassClient)
local PlotClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Plots.PlotClassClient)
local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local Sync = require(ReplicatedStorage.Shared.Features.Plot.Modules.Sync)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local plotClient = {}

local plotCFrames = game.Workspace.PlotCFrames :: Folder

function plotClient.init(self:plotClient)
    self.networker = networker.client.new("plotFeature", self)

    Sync:init()

    self.plot = nil :: PlotClassClient.plotClass?
    self.plotClaimed = signal.new()

    self.notPlayerPlots = {} :: {
        [number]: NotPlayersPlotClassClient.plotClass,
    }

    for _, point:Part in plotCFrames:GetChildren() do
        local index = tonumber(point.Name)
        self.notPlayerPlots[index] = NotPlayersPlotClassClient.new {
            Index = index,
            CFrame = point.CFrame,
            ConveyerLevel = 1
        }
    end

    PlotSlice.attemptPurchaseCrate:Connect(function()
        local success = self.networker:fetch("attemptPurchaseCrate")
        if success then
            self:removeConveyerCrate()
        else
            local crateInfo = dataservice:get({"CurrentCrate"}) :: DataTemplate.CrateInfo
            MonitizationServiceClient:promptProduct(Crates[crateInfo.Name].ProductId)
        end
    end)

    PlotSlice.attemptSkipCrate:Connect(function()
        local crateInfo = self.networker:fetch("attemptSkipCrate")
        self:skipConveyerCrate(crateInfo)
    end)

    PlotSlice.attemptUnlockStand:Connect(function()
        self.networker:fire("attemptUnlockStand")
    end)


end

function plotClient.claim(self:plotClient, index:number, startingTime:number, currentTick:number) 
    Sync.startTime = startingTime
    Sync.tick = currentTick
    
    self.notPlayerPlots[index]:destroy()
    self.notPlayerPlots[index] = nil

    local plotCFrame = plotCFrames:WaitForChild(tostring(index))
    
    self.plot = PlotClassClient.new {
        Index = index,
        CFrame = plotCFrame.CFrame,
    }
    
    local playerData = dataservice:get() :: DataTemplate.data
    for stand, standInfo in playerData.Stands do
        self.plot:unlockStand(stand)
        self.plot:place(stand, standInfo)
    end

    self.plot.promptTriggered:Connect(function(stand:number, text: string)
        if text == "Place" then
            self.networker:fire("attemptPlace", stand)
        elseif text == "Remove" then
            self.networker:fire("attemptRemove", stand)
        elseif text == "Open" then
            self.networker:fire("attemptOpen", stand)
        elseif text == "Skip Wait" then
            local thyme = self.plot.standClasses[stand].Class:getTime() :: number
            MonitizationServiceClient:promptProduct(PlotUtils:getSkipWaitProductId(thyme), {Stand=stand})
        end
    end)
    self.plotClaimed:Fire(self.plot)
end

function plotClient.unlockStand(self:plotClient, stand:number)
    self.plot:unlockStand(stand)
end

function plotClient.place(self:plotClient, stand:number, info:{})
    self.plot:place(stand, info)
end

function plotClient.remove(self:plotClient, stand:number)
    self.plot:remove(stand)
end

function plotClient.upgradeConveyer(self:plotClient, level:number)
    self.plot:upgradeConveyer(level)
end

function plotClient.removeConveyerCrate(self:plotClient)
    self.plot:removeConveyerCrate()
end

function plotClient.skipConveyerCrate(self:plotClient, crateInfo:DataTemplate.CrateInfo)
    self.plot:skipConveyerCrate(crateInfo)
end

function plotClient.getPlot(self:plotClient)
    return self.plot or self.plotClaimed:Wait() :: PlotClassClient.plotClass
end

function plotClient.NPClaim(self:plotClient, index:number, playerData:DataTemplate.data)
    self.notPlayerPlots[index]:claim()
    for stand, standInfo in playerData.Stands do
        self.notPlayerPlots[index]:unlockStand(stand)
        self.notPlayerPlots[index]:place(stand, standInfo)
    end
end

function plotClient.NPUnclaim(self:plotClient, index:number)
    self.notPlayerPlots[index]:unclaim()
end

function plotClient.NPUnlockStand(self:plotClient, index:number, stand:number)
    self.notPlayerPlots[index]:unlockStand(stand)
end

function plotClient.NPPlace(self:plotClient,index, stand:number, info:{})
    self.notPlayerPlots[index]:place(stand, info)
end

function plotClient.NPRemove(self:plotClient,index, stand:number)
    self.notPlayerPlots[index]:remove(stand)
end

function plotClient.NPUpgradeConveyer(self:plotClient, index:number, level:number)
    self.notPlayerPlots[index]:upgradeConveyer(level)
end

type plotClient = typeof(plotClient)
return plotClient :: plotClient