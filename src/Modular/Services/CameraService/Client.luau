local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local client = {}

local camera = game.Workspace.CurrentCamera

local spring = vide.spring
local source = vide.source
local root = vide.root

--[[
    Initializes the CameraService client, sets up a BlurEffect on the camera, and creates reactive FOV spring sources.
]]
function client.init(self:client)
    local blur = camera:FindFirstChildWhichIsA("BlurEffect")
    if not blur then
        blur = Instance.new("BlurEffect")
    end
    blur.Parent = camera
    blur.Size = 0
    self.blur = blur

    root(function()
        self.cameraFOV = source(70)
        self.cameraSpring = spring(self.cameraFOV, 0, 0)
        vide.effect(function()
            camera.FieldOfView = self.cameraSpring()
        end)

        self.blurSize = source(0)
        self.blurSpring = spring(self.blurSize, 0, 0)
        vide.effect(function()
            self.blur.Size = self.blurSpring()
        end)
    end)
end

--[[
    Smoothly tweens the camera FOV to a target value using a spring.
    @param goal         = target field of view Eg: 90, 110
    @param period       = spring period (oscillation time in seconds) Eg: 0.4
    @param damping_ratio = spring damping ratio Eg: 1 (critically damped), 0.5 (underdamped)
]]
function client.tweenFOV(self:client, goal:number, period:number, damping_ratio)
    root(function()
        self.cameraSpring = spring(self.cameraFOV, period, damping_ratio)
    end)
    self.cameraFOV(goal)
end

--[[
    Smoothly tweens the camera blur size to a target value using a spring.
    @param goal         = target blur size Eg: 0, 24
    @param period       = spring period (oscillation time in seconds) Eg: 0.4
    @param damping_ratio = spring damping ratio Eg: 1 (critically damped), 0.5 (underdamped)
]]
function client.tweenBlur(self:client, goal:number, period:number, damping_ratio)
    root(function()
        self.blurSpring = spring(self.blurSize, period, damping_ratio)
    end)
    self.blurSize(goal)
end

type client = typeof(client)

return client :: client