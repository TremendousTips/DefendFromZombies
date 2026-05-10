local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpinPurchaseButton = require(script.components.SpinPurchaseButton)
local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local WheelItem = require(script.components.WheelItem)
local WheelInfo = require(ReplicatedStorage.Shared.Features.Wheel.Modules.WheelInfo)
local WheelProductIds = require(ReplicatedStorage.Shared.Features.Wheel.Modules.WheelProductIds)
local WheelSlice = require(ReplicatedStorage.Shared.Features.Wheel.WheelSlice)
local CameraServiceClient = require(ReplicatedStorage.Shared.Modular.Services.CameraService.CameraServiceClient)
local FunnelServiceClient = require(ReplicatedStorage.Shared.Modular.Services.FunnelService.FunnelServiceClient)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source
local create = vide.create
local spring = vide.spring
local effect = vide.effect

local MENU = "Wheel"

return function() 
    local visible = source(false)
    AppSlice.openMenu:Connect(function(menu: string)
        if MENU == menu then
            FunnelServiceClient:stepCompleted(AppConstants.FUNNELS.PURCHASE_SPIN, 2, "Opened Menu")
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
        WheelSlice.wheelVisible(visible())
    end)

    local sizeSource = source(UDim2.fromOffset(600, 600))
    local sizeSpring = spring(sizeSource, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)

    effect(function()
        if visible() then
            sizeSource(UDim2.fromOffset(600, 600))
        else
            sizeSource(UDim2.fromOffset(400, 400))
        end
    end)

    local wheelItems = {}
    for index, _ in WheelInfo do
        table.insert(wheelItems, WheelItem(index))
    end

    local rotSpring = spring(WheelSlice.wheelRotation, 0.1, 1)

    return AutoScaledFrame {
        Name = "Wheel",
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = sizeSpring,
        Visible = visible,
        Children = {
            StudButton {
                Name = "Exit",
                Size = UDim2.fromOffset(80, 80),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(1, 0),
                Color = "Red",
                BackgroundTransparency = 1,
                Activated = function()
                    visible(false)
                    WheelSlice.wheelVisible(false)
                    CameraServiceClient:tweenFOV(AppConstants.NORMAL_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
                    CameraServiceClient:tweenBlur(0, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
                end,
                Children = {
                    TextLabel {
                        Text = "X",
                        Size = UDim2.fromScale(0.9, 0.9),
                        StrokeThickness = 3,
                        StrokeColor = Color3.new(0.56, 0, 0),
                        Position = UDim2.fromScale(0.5, 0.5),
                    }
                }
            },
            ImageLabel {
                Name = "WheelBackground",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                Image = ImageIds.SpinWheel.Background,
                Children = wheelItems,
                Rotation = rotSpring,
            },
            ImageLabel {
                Name = "Picker",
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.03),
                Size = UDim2.fromOffset(60, 75),
                Image = ImageIds.SpinWheel.Picker,
            },
            StudButton {
                Name = "SpinButton",
                Size = UDim2.fromOffset(250, 75),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 1.1),
                Color = "Green",
                Activated = function()
                    WheelSlice.requestSpin:Fire()
                end,
                Children = {
                    TextLabel {
                        Name = "Text",
                        Text = function()
                            return `Spin ({WheelSlice.spins()}x)`    
                        end,
                        Size = UDim2.fromScale(0.9, 0.9),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        StrokeThickness = 3,
                    }
                }
            },
            Frame {
                Name = "Robux Buttons",
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(1, 15, 0.5, 0),
                Size = UDim2.fromOffset(300, 600),
                Children = {
                    create "UIListLayout" {
                        Padding = UDim.new(0, 25),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        FillDirection = Enum.FillDirection.Vertical,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    },
                    SpinPurchaseButton {
                        Spins = 1,
                        ProductId = WheelProductIds.Spin1.ProductId,
                    },
                    SpinPurchaseButton {
                        Spins = 10,
                        ProductId = WheelProductIds.Spin10.ProductId,
                    },
                    SpinPurchaseButton {
                        Spins = 100,
                        ProductId = WheelProductIds.Spin100.ProductId,
                    },
                }

            }
        }
    }
end
