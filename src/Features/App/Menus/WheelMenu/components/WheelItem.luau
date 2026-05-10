local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local WheelInfo = require(ReplicatedStorage.Shared.Features.Wheel.Modules.WheelInfo)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)


local SIZE = 300
local RADIUS = SIZE / 2
local ROT = 22.5

local create = vide.create

function getPosFromRot(rot: number)
    local rad = math.rad(rot)

    local x = math.sin(rad) * RADIUS
    local y = (1 - math.cos(rad)) * RADIUS
    
    return x, y
end
return function(rewardNum:number)
    local rot = ROT*((rewardNum*2)-1)
    local x, y =getPosFromRot(rot)


    return Frame {
        Size = UDim2.fromOffset(SIZE, SIZE),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5,1),
        Position = UDim2.new(0.5,x, 0.5,y),
        Rotation = rot,
        Children = {
            ImageLabel {
                Size = UDim2.fromOffset(100, 100),
                BackgroundTransparency = 1,
                Image = WheelInfo[rewardNum].Icon,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
            },
            TextLabel {
                Size = UDim2.fromOffset(100, 50),
                Text = WheelInfo[rewardNum].TopText,
                Position = UDim2.fromScale(0.5, 0.25),
                AnchorPoint = Vector2.new(0.5,0.5),
                StrokeThickness = 3,
                Children = {
                    create "UIGradient" {
                        Color = WheelInfo[rewardNum].Gradient,
                        Rotation = -90,
                    }
                }
            },
            TextLabel({
                Size = UDim2.fromOffset(60, 50),
                Text = `{WheelInfo[rewardNum].Percentage}%`,
                Position = UDim2.fromScale(0.5, 0.65),
                AnchorPoint = Vector2.new(0.5,0.5),
                StrokeThickness = 3,
            })
        }
    }
end