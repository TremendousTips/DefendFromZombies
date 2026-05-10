local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CrateClass = require(ReplicatedStorage.Shared.Features.Plot.Modules.Classes.Shared.CrateClass)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local visualCrateClass = {}

export type visualCrate = {
    crateClass: CrateClass.crate
}

type props = {
    Stand: number,
    CrateInfo: DataTemplate.CrateInfo,
}

function visualCrateClass.new(props:props)
    local self = setmetatable({}, visualCrateClass)

    self.crateClass = CrateClass.new(props)

    return self :: visualCrate
end

return visualCrateClass