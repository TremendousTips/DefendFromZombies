local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ConveyerCrateClassClient = require(script.Parent.ConveyerCrateClassClient)
local vide = require(ReplicatedStorage.Packages.vide)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local conveyerClass = {}
conveyerClass.__index = conveyerClass

type props = {
    CFrame: CFrame,
    Level: number,
}

export type conveyerClass = {
    cframe: CFrame,
    model: Model,

    currentCrate: ConveyerCrateClassClient.conveyerCrateClass?,

    sizeSource: vide.Source<number>,

    upgrade: ((self:conveyerClass, level:number)->()),
    skipCrate: ((self:conveyerClass)->()),
    removeCrate: ((self:conveyerClass)->()),
    spawnCrate: ((self:conveyerClass, crateInfo:DataTemplate.CrateInfo)->()),
}

local parent = Instance.new("Folder")
parent.Name = "Conveyers"
parent.Parent = workspace

local source = vide.source
local spring = vide.spring
local effect = vide.effect
local root = vide.root

function conveyerClass.new(props:props)
    local self = setmetatable({}, conveyerClass)
    
    self.cframe = props.CFrame
    
    local model = ReplicatedStorage.Assets.Conveyers:FindFirstChild(tostring(props.Level)):Clone() :: Model
    model.Parent = parent
    model:PivotTo(self.cframe)
    self.model = model
    

    root(function()
        self.sizeSource = source(1)
        local sizeSpring = spring(self.sizeSource, 0.2, 0.6)
        effect(function()
            self.model:ScaleTo(sizeSpring())
        end)
    end)

    return self :: conveyerClass
end

function conveyerClass.upgrade(self:conveyerClass, level:number)
    self.model:Destroy()
    local model = ReplicatedStorage.Assets.Conveyers:FindFirstChild(tostring(level)):Clone() :: Model
    model.Parent = parent
    model:PivotTo(self.cframe)
    self.model = model

    self.sizeSource(1.2)
    task.delay(0.15, function()
        self.sizeSource(1)
    end)
end

function conveyerClass.removeCrate(self:conveyerClass)
    if self.currentCrate then
        self.currentCrate:clean()
        self.currentCrate = nil
    end
end

function conveyerClass.destroy(self:conveyerClass)
    self.model:Destroy()
    if self.currentCrate then
        self.currentCrate:clean()
        self.currentCrate = nil
    end
    setmetatable(self, nil)
end

function conveyerClass.spawnCrate(self:conveyerClass, crateInfo:DataTemplate.CrateInfo)
    if self.currentCrate then
        self:skipCrate()
    end
    self.currentCrate = ConveyerCrateClassClient.spawned(crateInfo, self.model)
end

function conveyerClass.skipCrate(self:conveyerClass)
    task.spawn(function()
        self.currentCrate:skip(self.model)
    end)
end

return conveyerClass