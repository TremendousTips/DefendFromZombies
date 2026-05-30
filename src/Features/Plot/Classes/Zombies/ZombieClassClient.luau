local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Healthbar = require(script.Parent.Healthbar)
local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)
local Zombies = require(ReplicatedStorage.Shared.Features.Plot.Modules.Zombies)
local AnimationIds = require(ReplicatedStorage.Shared.Modular.Game.AnimationIds)
local zombieClass = {}
zombieClass.__index = zombieClass

export type zombieClass = {
    level: number,
    model: Model,
    health: number,
    CFrame: CFrame,

    died: signal.Signal<>,

    healthSource: vide.Source<number>,

    anim: AnimationTrack,

    getCFrame: ((self:zombieClass)->(CFrame)),
    remove:((self:zombieClass)->())
}

type props = {
    Level: number,
    Plot: Model,
}

local parent = Instance.new("Folder")
parent.Name = "Zombies"
parent.Parent = game.Workspace

local source = vide.source
local root = vide.root

function zombieClass.new(props:props)
    local self = setmetatable({}, zombieClass)

    local floors = props.Plot.Floors:GetChildren()
    local floor = floors[math.random(1, #floors)] :: Part
    local model = ReplicatedStorage.Assets.Zombies:FindFirstChild(props.Level):Clone() :: Model
    model.Parent = parent
    
    local CFrame = CFrame.new(floor.Position + Vector3.new(
        math.random(-1,1)*math.random(1, floor.Size.X/2), 
        0,
        math.random(-1,1)*math.random(1, floor.Size.Z/2)
    ))

    model.PrimaryPart.Anchored = true
    model:PivotTo(CFrame)
    model:ScaleTo(0.5)
    self.CFrame = CFrame

    local animator = model.Humanoid.Animator :: Animator
    local animInstance = Instance.new("Animation")
    animInstance.AnimationId = AnimationIds[math.random(1, #AnimationIds)]
    self.anim = animator:LoadAnimation(animInstance)
    self.anim:Play()

    self.level = props.Level
    self.health = Zombies:getHealthFromLevel(props.Level)

    root(function()
        self.healthSource = source(self.health)

        local healthBar = Healthbar {
            Health = self.healthSource,
            MaxHealth = Zombies:getHealthFromLevel(props.Level)
        }
        healthBar.Parent = model.Head

    end)

    self.died = signal.new()

    self.model = model

    return self :: zombieClass
end

function zombieClass.damage(self:zombieClass, damage:number)
    self.health = math.max(self.health-damage, 0)
    self.healthSource(self.health)
    if self.health == 0 then
        self:kill()
    end
end

function zombieClass.kill(self:zombieClass)
    self.model:Destroy()
    
    self.died:Fire()
    self:remove()
end

function zombieClass.getCFrame(self:zombieClass)
    return self.CFrame
end

function zombieClass.remove(self:zombieClass)
    self.died:Destroy()
    setmetatable(self, nil)
end

return zombieClass
