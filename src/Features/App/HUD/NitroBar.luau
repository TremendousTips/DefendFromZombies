local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local SwingingSlice = require(ReplicatedStorage.Shared.Features.Swinging.SwingingSlice)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)

local create = vide.create
local source = vide.source
local spring = vide.spring
local effect = vide.effect

return function()
    local progressSizeSource = source(UDim2.fromScale(0, 1))
    local progressSizeSpring = spring(progressSizeSource, 0.3, 1)

    effect(function()
        local total = SwingingSlice.totalNitro()
        local remaining = SwingingSlice.nitroRemaining()
        local ratio = if total > 0 then math.clamp(remaining / total, 0, 1) else 0
        progressSizeSource(UDim2.fromScale(ratio, 1))
    end)

    return AutoScaledFrame {
        Name = "Nitro Bar",
        Visible = SwingingSlice.inAir,
        Size = UDim2.fromOffset(800, 65),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -15),
        BackgroundColor3 = Color3.new(),
        BackgroundTransparency = 0.6,
        Children = {
            create "UIStroke" {
                Thickness = 4,
                BorderStrokePosition = Enum.BorderStrokePosition.Inner,
            },
            Frame {
                Name = "Progress",
                Size = progressSizeSpring,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0, 0.5),
                BackgroundTransparency = 0,
                Children = {
                    create "UIGradient" {
                        Color = Gradients.Golden,
                        Rotation = -90,
                    },
                    create "UIStroke" {
                        Thickness = 4,
                        BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                    }
                }

            },
            TextLabel {
                Size = UDim2.fromScale(0.9, 0.9),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                StrokeThickness = 3,
                Text = function()
                    local total = SwingingSlice.totalNitro()
                    local remaining = SwingingSlice.nitroRemaining()
                    local ratio = if total > 0 then math.clamp(remaining / total, 0, 1) else 0
                    return `{math.floor(ratio * 100)}% Nitro`
                end,
            },
        }
    }
end
