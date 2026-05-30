local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local crateClass = {}
crateClass.__index = crateClass

type props = {
    Stand: number,
    CrateInfo: DataTemplate.CrateInfo,
}

export type crateClass = {
    crateInfo: DataTemplate.CrateInfo,
    time: number,


    getTime: ((self:crateClass)->(number)),
    tick: ((self:crateClass)->()),
    remove: ((self:crateClass)->()),
}

local parent = Instance.new("Folder") 
parent.Name = "Crates"
parent.Parent = game.Workspace

function crateClass.new(props:props)
    local self = setmetatable({}, crateClass)

    self.crateInfo = props.CrateInfo

    if not props.CrateInfo.Time then
        self.time = Crates[props.CrateInfo.Name].Time
    else
        self.time = props.CrateInfo.Time
    end

    return self :: crateClass
end

function crateClass.getTime(self:crateClass)
    return self.time
end

function crateClass.tick(self:crateClass)
    self.time = math.max(self.time-1, 0)
end

function crateClass.remove(self:crateClass)
    setmetatable(self, nil)  
end

return crateClass