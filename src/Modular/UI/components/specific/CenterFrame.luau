local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StudButton = require(script.Parent.StudButton)
local StudImage = require(script.Parent.StudImage)
local vide = require(ReplicatedStorage.Packages.vide)
local AutoScaledFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AutoScaledFrame)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)

type props = {
    Name: string,
    MainBarColor: string,
    Icon: string,
    Visible: boolean,
    TopY: number,
    Size: UDim2,
    Closed: (()->())?,
    Children: {}?,
}

local create = vide.create
local effect = vide.effect
local source = vide.source
local spring = vide.spring

return function(props:props)
    local children = {
        create "UIStroke" {
            Thickness = 4,
            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
        },
        StudImage {
            Name = "MainBar",
            Size = UDim2.fromOffset(props.Size.X.Offset-props.TopY, props.TopY),
            AnchorPoint = Vector2.new(0,1),
            Color = props.MainBarColor,
            BackgroundTransparency = 1,
            Children = {
                ImageLabel {
                    Name = "Icon",
                    Size = UDim2.fromOffset(props.TopY-5, props.TopY-5),
                    BackgroundTransparency = 1,
                    Image = props.Icon,
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.new(0,7, 0.5, 0)
                },
                TextLabel {
                    Text = props.Name,
                    Size = UDim2.fromScale(0.5, 0.8),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    StrokeThickness = 3,
                    Position = UDim2.new(0,props.TopY + 15, 0.5,0),
                    AnchorPoint = Vector2.new(0,0.5),
                }
            }
        },
        StudButton {
            Name = "Exit",
            Size = UDim2.fromOffset(props.TopY, props.TopY),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(1,-props.TopY /2 , 0,-props.TopY/2),
            Color = "Red",
            BackgroundTransparency = 1,
            Activated = function()
                if props.Closed then
                    props.Closed()
                end
                props.Visible(false)
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
        }
    }

    if not props.Children then
        props.Children = {}
    end
    for _, v in pairs(children) do
        table.insert(props.Children, v)
    end

    local position_source = source(UDim2.new(0.5,0, 0.6, props.TopY/2))

    effect(function()  
        if props.Visible() then
            return position_source(UDim2.new(0.5,0, 0.5,props.TopY/2))
        else
            return position_source(UDim2.new(0.5,0, 0.6, props.TopY/2))
        end
    end)

    local position_spring = spring(position_source, 0.15, 0.4)

    return AutoScaledFrame {
        Name = props.Name,
        Size = props.Size,
        BackgroundTransparency = .6,
        BackgroundColor3 = Color3.new(.1,.1,.1),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = position_spring,
        Visible = props.Visible,
        Children = props.Children
    }
end