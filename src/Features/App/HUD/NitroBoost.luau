local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppProductIds = require(ReplicatedStorage.Shared.Features.App.Modules.AppProductIds)
local SwingingSlice = require(ReplicatedStorage.Shared.Features.Swinging.SwingingSlice)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local AnimatedButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AnimatedButton)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)

local create = vide.create

local X = 250
local Y = 80

return function()
    return AutoScaledFrame {
        Name = "NitroBoost",
        Size = UDim2.fromOffset(X, Y),
        AnchorPoint = Vector2.new(0.5,0.5),
        Visible = SwingingSlice.inAir,
        Position = UDim2.fromScale(0.5, 0.65),
        Children = {
            AnimatedButton {
                Name = "Button",
                Size = UDim2.fromOffset(X, Y),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5,0.5),
                Activated = function()
                        MonitizationServiceClient:promptProduct(AppProductIds.BoostNitro.ProductId)
                end,
                Children = {
                    Frame {
                        Size = UDim2.fromScale(1, 1),
                        BackgroundColor3 = Color3.new(),
                        BackgroundTransparency = 0.6,
                        Children = {
                            create "UIStroke" {
                                Thickness = 4,
                                BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                            },
                            TextLabel {
                                Name = "Boost",
                                Size = UDim2.fromScale(0.9, 0.9),
                                AnchorPoint = Vector2.new(0.5,0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                StrokeThickness = 3,
                                Text = "BOOST?",
                                Children = {
                                    create "UIGradient" {
                                        Color = Gradients.Golden,
                                        Rotation = -90
                                    }
                                }
                            },
                            TextLabel {
                                Name = "2x",
                                Position = UDim2.fromScale(1, 0),
                                AnchorPoint = Vector2.new(0.5,0.5),
                                Text = "2x",
                                StrokeThickness = 3,
                                Size = UDim2.fromScale(0.3, 0.3),
                                Rotation = 15,
                                Children = {
                                    create "UIGradient" {
                                        Color = Gradients.Bloodlit,
                                        Rotation = -90
                                    }
                                }
                            },
                            TextLabel {
                                Name = "Cheap",
                                Size = UDim2.fromScale(0.4, 0.3),
                                AnchorPoint = Vector2.new(0.5,0.5),
                                Position = UDim2.fromScale(0.5, 1),
                                Text = "CHEAP",
                                StrokeThickness = 3,
                            }
                        },
                    }
                }
            },            
            
        }
    }
end
