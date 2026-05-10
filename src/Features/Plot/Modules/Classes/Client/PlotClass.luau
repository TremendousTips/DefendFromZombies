local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VisualTowerClass = require(script.Parent.VisualTowerClass)
local VisualCrateClass = require(ReplicatedStorage.Shared.Features.Plot.Modules.Classes.Client.VisualCrateClass)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)

local plotClass = {}
plotClass.__index = plotClass

export type plotClass = {
    owner: Player?,

    model: Model,

    stands: {},
    zombies: {},
}

type props = {
    Owner: Player?,
    Model: Model,
}

function plotClass.new(props:props)
    local self = setmetatable({}, plotClass)

    self.owner = props.Owner

    self.model = props.Model

    return self :: plotClass
end

function plotClass.claim(self:plotClass, player:Player)
    self.owner = player
    local stands = {}
    for stand:number, info:DataTemplate.TowerInfo|DataTemplate.CrateInfo in stands do
        if info.Type == "Tower" then
            self.stands[stand] = VisualTowerClass.new {
                Stand = stand,
                TowerInfo = info,
            }
        elseif info.Type == "Crate" then
            self.stands[stand] = VisualCrateClass.new {
                Stand = stand,
                CrateInfo = info
            }
        end
    end
end

function plotClass.unclaim(self:plotClass)
    self.owner = nil
    for _, stand in self.stands do
        stand:clean()
    end
    for _, zombie in self.zombies do
        zombie:clean()
    end
end

return plotClass