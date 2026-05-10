local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local CurrencyFrame = require(ReplicatedStorage.Shared.Features.App.HUD.Components.CurrencyFrame)
local LeftSideBarButton = require(ReplicatedStorage.Shared.Features.App.HUD.Components.LeftSideBarButton)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local RebirthSlice = require(ReplicatedStorage.Shared.Features.Rebirth.RebirthSlice)
local RewardInfo = require(ReplicatedStorage.Shared.Features.Rewards.Modules.RewardInfo)
local RewardsSlice = require(ReplicatedStorage.Shared.Features.Rewards.RewardsSlice)
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

    local rebirthNotification = source(false)

    effect(function()
        if RebirthSlice.currentDistance() >= RebirthSlice.neededDistance() then
            rebirthNotification(true)
        else
            rebirthNotification(false)
        end
    end)

    local rewardsNotification = source(false)

    effect(function()
        local claimed = RewardsSlice.claimedIndexes()
        local lastClaim = RewardsSlice.lastClaimTime()
        local nowTime = RewardsSlice.now()
        local claimable = false
        for idx = 1, #RewardInfo do
            if claimed[idx] then
                continue
            end
            if idx > 1 and not claimed[idx - 1] then
                continue
            end
            local cooldown = (idx - 1) * 86400
            if lastClaim + cooldown - nowTime <= 0 then
                claimable = true
                break
            end
        end
        rewardsNotification(claimable)
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
            CurrencyFrame {
                Currency = "Cash",
                Image = ImageIds.Icons.Cash,
                BackgroundColor = "Green",
                Amount = AppSlice.cashAmount
            },
            CurrencyFrame {
                Currency = "Trophy",
                Image = ImageIds.Icons.Trophy,
                BackgroundColor = "Gold",
                Amount = AppSlice.winsAmount
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
                        Notification = rebirthNotification
                    },
                    LeftSideBarButton {
                        Name = "Rewards",
                        Icon = ImageIds.Icons.Calendar,
                        BackgroundColor = "Blue",
                        Activated = function()
                            AppSlice.openMenu:Fire("Rewards")
                        end,
                        Notification = rewardsNotification
                    },
                }
            }
        }
    }
end