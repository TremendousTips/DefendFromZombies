local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local PlotClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Plots.PlotClassClient)
local plotClient = {}

local plotCFrames = game.Workspace.PlotCFrames :: Folder

function plotClient.init(self:plotClient)
    self.networker = networker.client.new("plotFeature", self)

    self.plots = {} :: {
        [number]: PlotClassClient.plotClass
    }

    for _, plotCFrame:Part in plotCFrames:GetChildren() do
        local index = tonumber(plotCFrame.Name) 
        self.plots[index] = PlotClassClient.new {
            Index = index,
            CFrame = plotCFrame.CFrame,
        }
    end
end

function plotClient.getPlayerPlot(self:plotClient, player:Player)
    for _, plot in self.plots do
        if plot:getOwner() == player then
            return plot
        end
    end
    return nil
end


function plotClient.playerAdded(self:plotClient, player:Player)
    
end

function plotClient.playerRemoved(self:plotClient, player:Player)
    
end

function plotClass.updatePlayerInfo(self:plotClient, player:Player)
    
end

type plotClient = typeof(plotClient)
return plotClient :: plotClient