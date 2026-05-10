local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local RebirthSlice = require(ReplicatedStorage.Shared.Features.Rebirth.RebirthSlice)
local CameraServiceClient = require(ReplicatedStorage.Shared.Modular.Services.CameraService.CameraServiceClient)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local CenterFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.CenterFrame)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source
local create = vide.create
local spring = vide.spring
local effect = vide.effect

local MENU = "Rebirth"

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

    local progressSizeSource = source(UDim2.fromScale(0.5, 1))
    local progressSizeSpring = spring(progressSizeSource, 0.3, 1) 

    effect(function()
        progressSizeSource(UDim2.fromScale(math.min(RebirthSlice.currentDistance()/RebirthSlice.neededDistance(), 1), 1))
    end)
    
    return CenterFrame {
        Name = MENU,
        MainBarColor = "Red",
        Visible = visible,
        Icon = ImageIds.Icons.Rebirth,
        Size = UDim2.fromOffset(730, 460),
        TopY = 84,
        Closed = function()
            CameraServiceClient:tweenFOV(AppConstants.NORMAL_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            CameraServiceClient:tweenBlur(0, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
        end,
        Children = {
            StudButton {
                Name = "RebirthButton",
                Size = UDim2.fromOffset(250, 80),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.86),
                Color = "Green",
                Activated = function()
                    RebirthSlice.requestRebirth:Fire()
                end,
                Children = {
                    TextLabel {
                        Name = "Text",
                        Size = UDim2.fromScale(0.9, 0.9),
                        Text = "Rebirth!",
                        StrokeThickness = 3,
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 0.5)
                    }
                }
            },
            TextLabel {
                Name = "Text",
                Size = UDim2.fromScale(0.8, 0.5),
                Text = "Rebirthing will double your coins, but reset your coins, swing, and upgrades",
                StrokeThickness = 3,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.3)
            },
            Frame {
                Name = "ProgressBar",
                Size = UDim2.fromOffset(550, 50),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.67),
                BackgroundTransparency = 0.6,
                BackgroundColor3 = Color3.new(),
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
                            return `{math.floor(RebirthSlice.currentDistance())} / {RebirthSlice.neededDistance()} Studs`
                        end,
                    },
                }
            }
        }
    }
end
