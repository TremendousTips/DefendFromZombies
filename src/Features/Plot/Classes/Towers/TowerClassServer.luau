local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ZombieClassServer = require(ServerScriptService.Features.Plot.Classes.Zombies.ZombieClassServer)
local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local towerClass = {}
towerClass.__index = towerClass

type props = {
    Stand: number,
    TowerInfo: DataTemplate.TowerInfo,
}

export type towerClass = {
    getDamage: ((self:towerClass)->(number)),
    attack: ((self:towerClass, zombie:ZombieClassServer.zombieClass)->()),
    remove: ((self:towerClass)->())
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

function towerClass.attack(self:towerClass, zombie:ZombieClassServer.zombieClass)
    zombie:damage(self:getDamage())
end

function towerClass.remove(self:towerClass)
    setmetatable(self, nil)
end

return towerClass