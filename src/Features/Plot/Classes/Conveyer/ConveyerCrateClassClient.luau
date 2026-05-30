local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ConveyerCrateUI = require(script.Parent.ConveyerCrateUI)
local trove = require(ReplicatedStorage.Packages.trove)
local PlotSlice = require(ReplicatedStorage.Shared.Features.Plot.PlotSlice)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local conveyerCrateClass = {}
conveyerCrateClass.__index = conveyerCrateClass


export type conveyerCrateClass = {
    model: Model,

    trove: trove.Trove,

    skip: ((self:conveyerCrateClass, conveyer:Model)->()),
    moveTo: ((self:conveyerCrateClass, conveyer:Model)->()),
    clean: ((self:conveyerCrateClass)->())
}

function conveyerCrateClass.spawned(crateInfo:DataTemplate.CrateInfo, conveyer:Model)
    local self = setmetatable({}, conveyerCrateClass)

    self.trove = trove.new()

    local crateModel = ReplicatedStorage.Assets.Crates:FindFirstChild(crateInfo.Name):Clone() :: Model
    crateModel.Parent = game.Workspace


    self.model = crateModel
    self.model:PivotTo(conveyer:WaitForChild("StartPoint").CFrame)

    local ui = ConveyerCrateUI(crateInfo)
    ui.Parent = self.model.UI

    local proxPrompt = Instance.new("ProximityPrompt")
    proxPrompt.ActionText = "Buy"
    proxPrompt.HoldDuration = 0.45
    proxPrompt.RequiresLineOfSight = false
    proxPrompt.Parent = self.model.Center
    proxPrompt.Style = Enum.ProximityPromptStyle.Custom
    proxPrompt.MaxActivationDistance = 15

    local proxConnection = proxPrompt.Triggered:Connect(function()  
        PlotSlice.attemptPurchaseCrate:Fire()
    end)

    self.trove:Add(crateModel)
    self.trove:Add(proxConnection)

    self:moveTo(conveyer:FindFirstChild("MidPoint").Position, false)

    return self :: conveyerCrateClass
end

function conveyerCrateClass.clean(self:conveyerCrateClass)
    self.trove:Clean()
    self.trove:Destroy()
    setmetatable(self, nil)
end

function conveyerCrateClass.skip(self:conveyerCrateClass, conveyer:Model)
    self:moveTo(conveyer.EndPoint.Position, true)
    
    local modelPos = self.model.PrimaryPart.Position
    local lavaPos = conveyer.Lava.Position

    local magnitude = (modelPos - lavaPos).Magnitude

    local step = 0
    local connection = nil :: RBXScriptConnection
    local running = true
    connection = RunService.Heartbeat:Connect(function(deltaTime:number)
        step += 10 * deltaTime
        
        local percentage = math.clamp(step / magnitude, 0, magnitude)
        local position = modelPos + ((lavaPos - modelPos) * percentage)
        local y = (-step*(step-magnitude))

        self.model:PivotTo(CFrame.new(
            position.X,
            position.Y + y,
            position.Z  
        )*CFrame.Angles(0, math.rad(percentage*120), 0))
        if percentage == magnitude then
            running = false
            connection:Disconnect()
        end
    end)

    while running do
        task.wait()
    end

    self:clean()
end

function conveyerCrateClass.moveTo(self:conveyerCrateClass, position:Vector3, yeild:boolean?)
    local startingPos = self.model.PrimaryPart.Position
    local n = 0
    local connection = nil :: RBXScriptConnection
    local running = true
    connection = RunService.Heartbeat:Connect(function(deltaTime: number)  
        n += 200 * deltaTime
        self.model:PivotTo(CFrame.new(startingPos + (position - startingPos) * (math.clamp(n/100, 0, 1))))
        if n > 100 then
            running = false
            connection:Disconnect()
            return
        end
    end)
    
    
    if yeild then
        while running do
            task.wait()
        end
    end
end

return conveyerCrateClass