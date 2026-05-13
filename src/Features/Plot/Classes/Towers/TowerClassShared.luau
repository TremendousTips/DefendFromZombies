local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local towerClass = {}
towerClass.__index = towerClass

type props = {
    Stand: number,
    TowerInfo: DataTemplate.TowerInfo,
}

export type towerClass = {
    tbl: Towers.tower,

    getDamage: ((self:towerClass)->()),
    attack: ((self:towerClass, zombie:{})->()),

}

function towerClass.new(props:props)
    local self = setmetatable({}, towerClass)

    self.tbl = Towers[props.TowerInfo.Name]

    return self :: towerClass
end

function towerClass.getDamage(self:towerClass)
    local baseDamage = self.tbl.Damage :: number
    return baseDamage
end

function towerClass.attack(self:towerClass, zombie)
    zombie:damage(self:getDamage())
end

return towerClass