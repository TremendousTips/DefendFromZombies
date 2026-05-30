local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local TutorialSlice = require(ReplicatedStorage.Shared.Features.Tutorial.TutorialSlice)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)

local create = vide.create

return function()
    return AutoScaledFrame {
        Name = "Overlay",
        Visible = TutorialSlice.overlayVisible,
        Position = TutorialSlice.overlayPosition,
        Size = TutorialSlice.overlaySize,
        AnchorPoint = Vector2.new(0.5,0.5),
        ZIndex = 99,
        BackgroundTransparency = 1,
        Children = {
            create "UIStroke" {
                BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                Thickness = 10000,
                Transparency = 0.4
            },
            create "UICorner" {
                CornerRadius = UDim.new(0.1,0),
            }
        }
    }
end
