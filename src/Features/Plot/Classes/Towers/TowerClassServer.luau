local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerClassShared = require(ReplicatedStorage.Shared.Features.Plot.Classes.Towers.TowerClassShared)
local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local towerClass = {}
towerClass.__index = towerClass
setmetatable(towerClass, TowerClassShared)

type props = {
    Stand: number,
    TowerInfo: DataTemplate.TowerInfo,
}

function towerClass.new(props:props)
    local self = setmetatable({}, towerClass)

    self.tbl = Towers[props.TowerInfo.Name]

    return self
end

function towerClass.getDamage(self)
    local baseDamage = self.tbl.Damage :: number
    return baseDamage
end

function towerClass.attack(self, zombie)
    zombie:damage(self:getDamage())
end

return towerClass