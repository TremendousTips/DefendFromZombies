local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local towerClass = {}

export type tower = {
    owner: Player,
}

type props = {
    Stand: number,
    TowerInfo: DataTemplate.TowerInfo,
}

function towerClass.new(props:props)
    local self = setmetatable({}, towerClass)
    
    self.owner = props.Owner

    return self :: tower
end

function towerClass.attack(self:tower)
    
end

return towerClass