local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local signal = require(ReplicatedStorage.Packages.signal)
local PlotClient = require(ReplicatedStorage.Shared.Features.Plot.PlotClient)
local TutorialSlice = require(ReplicatedStorage.Shared.Features.Tutorial.TutorialSlice)

local camera = game.Workspace.CurrentCamera

return function()
    local completed = signal.new()

    task.wait(0.5)

    local target = PlotClient:getPlot().model.StandCFrames:FindFirstChild("1") :: Part

    local connection = nil :: RBXScriptConnection?

    TutorialSlice.overlayVisible(true)

    TutorialSlice.overlaySize(UDim2.fromOffset(200, 200))

    connection = RunService.RenderStepped:Connect(function()
        local screenPos = camera:WorldToViewportPoint(target.Position)

        local position = UDim2.fromOffset(
            screenPos.X,
            screenPos.Y
        )
        TutorialSlice.overlayPosition(position)
    end)

    PlotClient:getPlot().promptTriggered:Once(function()
        connection:Disconnect()
        TutorialSlice.overlayVisible(false)
        completed:Fire()
    end)

    return completed
end
