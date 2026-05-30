local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local ZombieClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Zombies.ZombieClassClient)
local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local TowerClassShared = require(script.Parent.TowerClassShared)
local TowerUI = require(script.Parent.TowerUI)
local towerClass = {}
towerClass.__index = towerClass
setmetatable(towerClass, TowerClassShared)

export type towerClass = {
    tbl: Towers.tower,

    model: Model,

    towerInfo: DataTemplate.TowerInfo,

    position: Vector3,

    sizeSource: vide.Source<number>,
    cframeSource: vide.Source<CFrame>,

    attack: ((self:towerClass, zombie:ZombieClassClient.zombieClass)->()),
    remove: ((self:towerClass)->()),

}

type props = {
    Plot: Model,
    Stand: number,
    TowerInfo: DataTemplate.TowerInfo,
}

local parent = Instance.new("Folder")
parent.Name = "Towers"
parent.Parent = game.Workspace

local source = vide.source
local effect = vide.effect
local spring = vide.spring
local root = vide.root

function towerClass.new(props:props)
    local self = setmetatable({}, towerClass)

    local standCFrame = props.Plot.StandCFrames:FindFirstChild(tostring(props.Stand)).CFrame

    local model = ReplicatedStorage.Assets.Towers:FindFirstChild(props.TowerInfo.Name):Clone() :: Model
    model.Parent = parent
    model:PivotTo(standCFrame)

    self.towerInfo = props.TowerInfo
    
    self.position = model.PrimaryPart.Position
    self.model = model

    local ui = TowerUI(props.TowerInfo)
    ui.Parent = model.PrimaryPart.UI

    root(function()
        self.sizeSource = source(1)
        self.cframeSource = source(standCFrame)
        local sizeSpring = spring(self.sizeSource, 0.2, 0.7)
        local cframeSpring = spring(self.cframeSource, 0.3, 0.8)
        effect(function()
            self.model:ScaleTo(sizeSpring())
        end)
        effect(function()
            self.model:PivotTo(cframeSpring())
        end)
    end)

    return self :: towerClass
end

function towerClass.attack(self:towerClass, zombie:ZombieClassClient.zombieClass)
    local lookAt = zombie:getCFrame()
    local newCFrame = CFrame.lookAt(self.position, lookAt.Position)
    self.cframeSource(newCFrame)
    task.spawn(function()
        self.sizeSource(1.2)
        task.wait(.15)
        self.sizeSource(1)
    end)
    zombie:damage(self:getDamage())
end

function towerClass.getDamage(self:towerClass)
    local baseDamage = Towers[self.towerInfo.Name].Damage :: number
    return baseDamage
end

function towerClass.remove(self:towerClass)
    self.model:Destroy()
    setmetatable(self, nil)
end

return towerClass