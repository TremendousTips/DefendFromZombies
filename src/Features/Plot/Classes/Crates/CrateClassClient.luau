local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CrateUI = require(script.Parent.CrateUI)
local charm = require(ReplicatedStorage.Packages.charm)
local vide = require(ReplicatedStorage.Packages.vide)
local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local crateClass = {}
crateClass.__index = crateClass

type props = {
    Plot: Model,
    Stand: number,
    CrateInfo: DataTemplate.CrateInfo,
}

export type crateClass = {
    crateInfo: DataTemplate.CrateInfo,
    model: Model,
    timeAtom: charm.Atom<number>,

    getTime: ((self:crateClass)->(number)),

    tick: ((self:crateClass)->()),
    remove: ((self:crateClass)->())
}

local parent = Instance.new("Folder") 
parent.Name = "Crates"
parent.Parent = game.Workspace

local atom = charm.atom

local root = vide.root

function crateClass.new(props:props)
    local self = setmetatable({}, crateClass)

    local standCFrame = props.Plot.StandCFrames:FindFirstChild(tostring(props.Stand)).CFrame

    local model = ReplicatedStorage.Assets.Crates:FindFirstChild(props.CrateInfo.Name):Clone() :: Model
    model.Parent = parent
    model:PivotTo(standCFrame)

    self.model = model
    self.crateInfo = props.CrateInfo

    self.timeAtom = atom(0)

    if not props.CrateInfo.Time then
        self.timeAtom(Crates[props.CrateInfo.Name].Time)
    else
        self.timeAtom(props.CrateInfo.Time)
    end


    

    root(function()  
        CrateUI {
            Parent = self.model.UI,
            CrateInfo = props.CrateInfo,
            TimeLeft = self.timeAtom
        }
    end)

    return self :: crateClass
end

function crateClass.getTime(self:crateClass)
    return self.timeAtom()
end

function crateClass.tick(self:crateClass)
    self.timeAtom(math.max(self.timeAtom()-1, 0))
end

function crateClass.remove(self:crateClass)
    self.model:Destroy()
    setmetatable(self, nil)
end

return crateClass