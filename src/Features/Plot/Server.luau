local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlotServerClass = require(ServerScriptService.Features.Plot.Modules.Classes.PlotServerClass)
local networker = require(ReplicatedStorage.Packages.networker)
local server = {}

local plotCFrames = game.Workspace.PlotCFrames :: Folder

function server.init(self:server)
    self.networker = networker.server.new("plotFeature", self)

    self.plots = {} :: {
        [number]: PlotServerClass.plot
    }

    for index, part in plotCFrames:GetChildren() do
        self.plots[index] = PlotServerClass.spawn(index, part)
    end
end


function server.playerAdded(self:server, player:Player)
    local plot = self:getUnclaimedPlot() :: PlotServerClass.plot
    plot:claim(player)
    self.networker:fire(player,"plotClaimed", plot.index)
end

function server.playerRemoved(self:server, player:Player)
    local plot = self:findPlayerPlot(player)
    plot:unclaim()
end

function server.findPlayerPlot(self:server, player:Player)
    for _, plot in self.plots do
        if plot.owner == player then
            return plot
        end
    end
    return nil
end

function server.getUnclaimedPlot(self:server)
    for _, plot in self.plots do
        if not plot:isClaimed() then
            return plot
        end
    end
    return nil
end

type server = typeof(server)

return server :: server