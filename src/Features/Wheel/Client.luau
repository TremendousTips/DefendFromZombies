local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local WheelSlice = require(script.Parent.WheelSlice)
local networker = require(ReplicatedStorage.Packages.networker)
local vide = require(ReplicatedStorage.Packages.vide)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local CameraServiceClient = require(ReplicatedStorage.Shared.Modular.Services.CameraService.CameraServiceClient)
local FunnelServiceClient = require(ReplicatedStorage.Shared.Modular.Services.FunnelService.FunnelServiceClient)

local ROT = 22.5
local IDLE_SPEED = 20
local SPIN_TURNS = 5

local client = {}

function client.init(self:client)
    self.networker = networker.client.new("wheelFeature", self)
    self.spinning = false

    self:startIdleSpin()

    WheelSlice.requestSpin:Connect(function()
        if self.spinning then return end
        local rolledIndex = self.networker:fetch("requestSpin")
        if rolledIndex then
            WheelSlice.rolledIndex(rolledIndex)
        end
    end)

    WheelSlice.spins(dataservice:get({"Spins"}))

    dataservice:getChangedSignal({"Spins"}):Connect(function(val:number)  
        WheelSlice.spins(val)
    end)

    vide.root(function()
        local first = true
        vide.effect(function()
            local index = WheelSlice.rolledIndex()
            if first then 
                first = false 
                return 
            end
            task.spawn(function()
                self:roll(index)
            end)
        end)
    end)
end

function client.boughtSpin(self:client)
    FunnelServiceClient:stepCompleted(AppConstants.FUNNELS.PURCHASE_SPIN, 4, "Purchased")
end

function client.startIdleSpin(self:client)
    if self.idleSpin then 
        self.idleSpin:Disconnect() 
    end
    self.idleSpin = RunService.RenderStepped:Connect(function(deltaTime: number)
        WheelSlice.wheelRotation(WheelSlice.wheelRotation()+(IDLE_SPEED*deltaTime))
    end)
end

function client.roll(self:client, rewardNum:number)
    if self.spinning then return end
    if self.idleSpin then
        self.idleSpin:Disconnect()
        self.idleSpin = nil
    end
    self.spinning = true

    local currentRot = WheelSlice.wheelRotation()
    local rot = ROT*((rewardNum*2)-1)
    local currentMod = currentRot % 360
    local targetMod = (360 - rot) % 360
    local goalRot = currentRot + (SPIN_TURNS*360) + ((targetMod - currentMod) % 360)
    local totalDistance = goalRot - currentRot

    task.spawn(function()
        CameraServiceClient:tweenFOV(100, 5, 1)
        task.wait(3.25)
        CameraServiceClient:tweenFOV(AppConstants.ZOOMED_FOV, .4, .6)
    end)

    while WheelSlice.wheelRotation() < goalRot do
        local remaining = goalRot - WheelSlice.wheelRotation()
        local progress = 1 - (remaining / totalDistance)
        local increment = math.max(1, remaining * 0.10)
        WheelSlice.wheelRotation(math.min(WheelSlice.wheelRotation() + increment, goalRot))
        local thyme = 0.01 + (progress * 0.05)
        task.wait(thyme)
    end

    task.wait(1)
    self.spinning = false
    self:startIdleSpin()
end

type client = typeof(client)

return client :: client
