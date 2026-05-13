local TowerClassShared = require(script.Parent.TowerClassShared)
local towerClass = {}
towerClass.__index = towerClass
setmetatable(towerClass, TowerClassShared)

function towerClass.new()
    local self = setmetatable({}, towerClass)

    return self
end

return towerClass