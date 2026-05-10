local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerClass = require(ReplicatedStorage.Shared.Features.Plot.Modules.Classes.Shared.TowerClass)
local visualTowerClass = {}

export type visualTower = {
    towerClass: TowerClass.tower
}

type props = {

}

function visualTowerClass.new(props:props)
    local self = setmetatable({}, visualTowerClass)

    self.towerClass = TowerClass.new(props)

    return self :: visualTower
end

return visualTowerClass