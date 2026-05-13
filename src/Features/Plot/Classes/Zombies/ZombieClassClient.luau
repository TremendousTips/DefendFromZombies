local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Plots.PlotClassClient)
local PlotClient = require(ReplicatedStorage.Shared.Features.Plot.PlotClient)
local ZombieClassShared = require(script.Parent.ZombieClassShared)
local zombieClass = {}
zombieClass.__index = zombieClass
setmetatable(zombieClass, ZombieClassShared)

export type zombieClass = {
    level: number,
    health: number,
    player: Player,
}

function zombieClass.clientNew(self:zombieClass)
    local plot = PlotClient:getPlayerPlot(self.player) :: PlotClassClient.plotClass    
end

return zombieClass :: zombieClass
