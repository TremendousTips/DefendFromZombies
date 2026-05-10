local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local LeftSideBarButton = require(ReplicatedStorage.Shared.Features.App.HUD.Components.LeftSideBarButton)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local WheelSlice = require(ReplicatedStorage.Shared.Features.Wheel.WheelSlice)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local create = vide.create
local source = vide.source
local spring = vide.spring
local effect = vide.effect

return function()
    local posSource = source(UDim2.new(1, -AppConstants.PADDING, 0.5,0))
    local posSpring = spring(posSource, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
    
    effect(function()
        if WheelSlice.wheelVisible() then
            posSource(UDim2.new(1.5, -AppConstants.PADDING, 0.5,0))
        else
            posSource(UDim2.new(1, -AppConstants.PADDING, 0.5,0))
        end
    end)

    local wheelNotification = source(false)

    effect(function()
        if WheelSlice.spins() > 0 then
            wheelNotification(true)
        else
            wheelNotification(false)
        end
    end)

    return AutoScaledFrame {
        Name = "RightSideBar",
        Size = UDim2.fromOffset(100, 500),
        AnchorPoint = Vector2.new(1,0.5),
        Position = posSpring,
        Children = {
            create "UIListLayout" {
                Padding = UDim.new(0, AppConstants.PADDING),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                FillDirection = Enum.FillDirection.Vertical,
            },
            LeftSideBarButton {
                Name = "Wheel",
                Icon = ImageIds.Icons.Wheel,
                BackgroundColor = "Purple",
                Activated = function()
                    AppSlice.openMenu:Fire("Wheel")
                end,
                Notification = wheelNotification
            },
            LeftSideBarButton {
                Name = "StarterPack",
                Icon = ImageIds.Icons.Gift,
                BackgroundColor = "Gold",
                Activated = function()
                    AppSlice.openMenu:Fire("Starterpack")
                end,
                Notification = source(true),
            },
        }
    }
end