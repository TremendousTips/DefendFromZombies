local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local FormatNumber = require(ReplicatedStorage.Shared.Modular.Math.FormatNumber)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)

local create = vide.create

return function()
    return AutoScaledFrame {
        Name = "Currency",
        Size = UDim2.fromOffset(300, 130),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0,15, 1, -15),
        Children = {
            TextLabel {
                Name = "CurrencyText",
                AnchorPoint = Vector2.new(0,0),
                Size = UDim2.fromScale(1, 0.7),
                Text = function()
                    return `${FormatNumber(AppSlice.cashAmount())}`
                end,
                StrokeThickness = 3,
                TextXAlignment = Enum.TextXAlignment.Left,
                Children = {
                    create "UIGradient" {
                        Color = Gradients.Cash,
                        Rotation = -90
                    },
                }
            },
            TextLabel {
                Name = "FriendBoost",
                AnchorPoint = Vector2.new(0,1),
                Size = UDim2.fromScale(1, 0.3),
                Position = UDim2.fromScale(0, 1),
                Text = "Friend boost: 0%",
                StrokeThickness = 3,
                TextXAlignment = Enum.TextXAlignment.Left,
            },
        }
    }
end
