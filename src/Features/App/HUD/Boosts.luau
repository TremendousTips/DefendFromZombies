local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local BoostButton = require(ReplicatedStorage.Shared.Features.App.HUD.Components.BoostButton)
local AppProductIds = require(ReplicatedStorage.Shared.Features.App.Modules.AppProductIds)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local FormatTime = require(ReplicatedStorage.Shared.Modular.UI.Modules.FormatTime)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local create = vide.create

local player = Players.LocalPlayer

local function canSendGameInvite(sendingPlayer)
	local success, canSend = pcall(function()
		return SocialService:CanSendGameInviteAsync(sendingPlayer)
	end)
	return success and canSend
end

return function()
    return AutoScaledFrame {
        Name = "Boosts",
        Size = UDim2.fromOffset(95*4 -15, 90),
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,15,1,-15),
        Children = {
            TextLabel {
                Name = "Label",
                Text = `{ImageIds.Icons.Robux} CHEAP {ImageIds.Icons.Robux}`,
                Size = UDim2.fromScale(1, 0.5),
                AnchorPoint = Vector2.new(0.5,1),
                Position = UDim2.fromScale(0.5, -.1),
                TextYAlignment = Enum.TextYAlignment.Bottom,
                StrokeThickness = 3,
                Children = {
                    create "UIGradient" {
                        Color = ColorSequence.new(Color3.new(0, 1, 0.164706), Color3.new(0.898039, 1, 0)),
                        Rotation = -90,
                    }
                }
            },
            Frame {
                Name = "Boosts",
                Size = UDim2.fromScale(1,1),
                Children = {
                    create "UIListLayout" {
                        Padding = UDim.new(0, 15),
                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        FillDirection = Enum.FillDirection.Horizontal,
                    },
                    BoostButton {
                        Icon = ImageIds.Icons.Friends,
                        Label = "Friends Boost!",
                        Text = "0%",
                        Activated = function()
                            local canInvite = canSendGameInvite(player)
                            if canInvite then
                                SocialService:PromptGameInvite(player)
                            end
                        end,
                    },
                    BoostButton {
                        Icon = ImageIds.Potions.CashPotion,
                        Label = "2x Cash!",
                        Text = function()
                            return FormatTime(AppSlice.cashPotionTime())
                        end,
                        Activated = function()
                            MonitizationServiceClient:promptProduct(AppProductIds.CashPotion.ProductId)
                        end,
                    },
                    BoostButton {
                        Icon = ImageIds.Potions.SpeedPotion,
                        Label = "2x Speed!",
                        Text = function()
                            return FormatTime(AppSlice.speedPotionTime())
                        end,
                        Activated = function()
                            MonitizationServiceClient:promptProduct(AppProductIds.SpeedPotion.ProductId)
                        end,
                    },
                    BoostButton {
                        Icon = ImageIds.Potions.WinsPotion,
                        Label = "2x Wins!",
                        Text = function()
                            return FormatTime(AppSlice.winsPotionTime())
                        end,
                        Activated = function()
                            MonitizationServiceClient:promptProduct(AppProductIds.WinsPotion.ProductId)
                        end,
                    },
                }
            }
        }
    }
end
