local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StartpackItem = require(script.components.StartpackItem)
local vide = require(ReplicatedStorage.Packages.vide)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local AppProductIds = require(ReplicatedStorage.Shared.Features.App.Modules.AppProductIds)
local CameraServiceClient = require(ReplicatedStorage.Shared.Modular.Services.CameraService.CameraServiceClient)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local CenterFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.CenterFrame)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source
local create = vide.create

local MENU = "Starterpack"

return function()
    local visible = source(false)
    AppSlice.openMenu:Connect(function(menu: string)
        if MENU == menu then
            visible(not visible())
            if not visible() then
                CameraServiceClient:tweenFOV(AppConstants.NORMAL_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
                CameraServiceClient:tweenBlur(0, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            else
                CameraServiceClient:tweenFOV(AppConstants.ZOOMED_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
                CameraServiceClient:tweenBlur(AppConstants.ZOOM_BLUR, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            end
        else
            visible(false)
        end
    end)
    
    local rewardChildren = {
        create "UIListLayout" {
            Padding = UDim.new(0, 15),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
        }
    }

    for _, reward in AppProductIds.Starterpack.Params do
        table.insert(rewardChildren, StartpackItem(reward))
    end

    local price = source(0)
    
    local productId = AppProductIds.Starterpack.ProductId
    
    task.spawn(function()
        price(MonitizationServiceClient:getProductPrice(productId))
    end)

    return CenterFrame {
        Name = MENU,
        Size = UDim2.fromOffset(720, 450),
        TopY = 84,
        MainBarColor = "Gold",
        Icon = ImageIds.Icons.Gift,
        Visible = visible,
        Closed = function()
            CameraServiceClient:tweenFOV(AppConstants.NORMAL_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            CameraServiceClient:tweenBlur(0, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
        end,
        Children = {
            Frame {
                Name = "Rewards",
                Size = UDim2.fromOffset(600, 150),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.4),
                Children = rewardChildren
            },
            StudButton {
                Name = "PurchaseButton",
                Color = "Gold",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.8),
                Size = UDim2.fromOffset(250, 75),
                Activated = function()
                    MonitizationServiceClient:promptProduct(productId)
                end,
                Children = {
                    TextLabel {
                        Name = "Label",
                        Size = UDim2.fromScale(0.9, 0.9),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Text = "GET",
                        StrokeThickness = 3,
                    },
                    TextLabel {
                        Name = "Cost",
                        Size = UDim2.fromScale(0.7, 0.45),
                        AnchorPoint = Vector2.new(.5,0.4),
                        Position = UDim2.fromScale(.5, 1),
                        Text = function()
                            return `{ImageIds.Icons.Robux}{price()}`
                        end,
                        StrokeThickness = 3,
                        Children = {
                            create "UIGradient" {
                                Color = Gradients.Cash,
                                Rotation = -90
                            }
                        }
                    }
                }
            }
        }
    }
end
