local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local RightSideMonitizationButton = require(ReplicatedStorage.Shared.Features.App.HUD.Components.RightSideMonitizationButton)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local WheelSlice = require(ReplicatedStorage.Shared.Features.Wheel.WheelSlice)
local Gamepasses = require(ReplicatedStorage.Shared.Modular.Game.Gamepasses)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local FormatTime = require(ReplicatedStorage.Shared.Modular.UI.Modules.FormatTime)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local create = vide.create
local source = vide.source
local spring = vide.spring
local effect = vide.effect

return function()
    local posSource = source(UDim2.fromScale(.9, 0.5))
    local posSpring = spring(posSource, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
    
    effect(function()
        if WheelSlice.wheelVisible() then
            posSource(UDim2.fromScale(1.4, 0.5))
        else
            posSource(UDim2.fromScale(.9, 0.5))
        end
    end)

    return AutoScaledFrame {
        Name = "RightSideMonitization",
        Size = UDim2.fromOffset(200, 600),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = posSpring,
        Children = {
            create "UIListLayout" {
                Padding = UDim.new(0, 40),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            },
            RightSideMonitizationButton {
                Name = "OP",
                TopText = "OP",
                CenterText = function()
                    local t = AppSlice.groupRewardCooldown()
                    return if t > 0 then FormatTime(t) else "READY!"
                end,
                BottomText = "FREE!",
                Icon = ImageIds.Icons.RedGift,
                Activated = function()
                    AppSlice.requestGroupReward:Fire()
                end
            },
            RightSideMonitizationButton {
                Name = "Double Wins",
                TopText = `{ImageIds.Icons.Robux}5`,
                BottomText = "DOUBLE WINS",
                Icon = ImageIds.Icons.Trophy,
                Activated = function()
                    MonitizationServiceClient:promptPass(Gamepasses.DoubleWins)
                end
            },
            RightSideMonitizationButton {
                Name = "Double Speed",
                TopText = `{ImageIds.Icons.Robux}3`,
                BottomText = "DOUBLE SPEED",
                Icon = ImageIds.Icons.UltraLuck,
                Activated = function()
                    MonitizationServiceClient:promptPass(Gamepasses.DoubleSpeed)
                end
            },
        }
    }
end
