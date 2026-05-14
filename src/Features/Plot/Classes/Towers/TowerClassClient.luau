local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local TowerClassShared = require(script.Parent.TowerClassShared)
local towerClass = {}
towerClass.__index = towerClass
setmetatable(towerClass, TowerClassShared)

export type towerClass = {
    tbl: Towers.tower,

    getDamage: ((self:towerClass)->()),
    attack: ((self:towerClass, zombie:{})->()),

}

function towerClass.new()
    local self = setmetatable({}, towerClass)

    return self
end

return towerClass