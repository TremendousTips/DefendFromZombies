local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local LeftSideBarButton = require(ReplicatedStorage.Shared.Features.App.HUD.Components.LeftSideBarButton)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local WheelSlice = require(ReplicatedStorage.Shared.Features.Wheel.WheelSlice)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local create = vide.create
local source = vide.source
local spring = vide.spring
local effect = vide.effect

return function()
    local posSource = source(UDim2.new(0, AppConstants.PADDING, 0.5,0))
    local posSpring = spring(posSource, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
    
    effect(function()
        if WheelSlice.wheelVisible() then
            posSource(UDim2.new(-.5, AppConstants.PADDING, 0.5,0))
        else
            posSource(UDim2.new(0, AppConstants.PADDING, 0.5,0))
        end
    end)

    return AutoScaledFrame {
        Name = "LeftSideBar",
        Size = UDim2.fromOffset(300, 500),
        AnchorPoint = Vector2.new(0,0.5),
        Position = posSpring,
        Children = {
            create "UIListLayout" {
                Padding = UDim.new(0, AppConstants.PADDING),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                FillDirection = Enum.FillDirection.Vertical,
            },
            LeftSideBarButton {
                Name = "Shop",
                Icon = ImageIds.Icons.Shop,
                BackgroundColor = "Gold",
                Size = UDim2.fromOffset(250, 85),
                Activated = function()
                    AppSlice.openMenu:Fire("Shop")
                end,
                ImagePosition = UDim2.fromScale(0.175, 0.5),
                TextPosition = UDim2.fromScale(0.6, 0.5),
                TextSize = UDim2.fromScale(0.7, 0.7),
                Notification = source(false)
            },
            Frame {
                Name = "Buttons",
                Size = UDim2.fromOffset(220, 110),
                Children = {
                    create "UIListLayout" {
                        Padding = UDim.new(0, AppConstants.PADDING),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        FillDirection = Enum.FillDirection.Horizontal,
                    },
                    LeftSideBarButton {
                        Name = "Rebirth",
                        Icon = ImageIds.Icons.Rebirth,
                        BackgroundColor = "Red",
                        Activated = function()
                            AppSlice.openMenu:Fire("Rebirth")
                        end,
                        Notification = source(false)
                    },
                    LeftSideBarButton {
                        Name = "Rewards",
                        Icon = ImageIds.Icons.Calendar,
                        BackgroundColor = "Blue",
                        Activated = function()
                            AppSlice.openMenu:Fire("Rewards")
                        end,
                        Notification = source(true)
                    },
                }
            }
        }
    }
end