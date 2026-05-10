local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AnimatedButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AnimatedButton)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)
local COLORS = {
    Blue = {
        Main = ColorSequence.new(Color3.new(0, 0.635294, 1),Color3.new(0, 0.968627, 1)),
        InnerStroke = ColorSequence.new(Color3.new(0.341176, 0.701961, 1),Color3.new(0.521569, 0.968627, 1)),
        Bottom = Color3.new(0.094118, 0.486275, 1),
        OuterStroke = Color3.new(0, 0.105882, 0.301961),
    },
    Green = {
        Main = ColorSequence.new(Color3.new(0, 1, 0.015686),Color3.new(0.784314, 1, 0)),
        InnerStroke = ColorSequence.new(Color3.new(0.458824, 1, 0.458824),Color3.new(0.878431, 1, 0.541176)),
        Bottom = Color3.new(0.058824, 0.486275, 0.062745),
        OuterStroke = Color3.new(0, 0.137255, 0.007843),
    },
    Purple = {
        Main = ColorSequence.new(Color3.new(0.54902, 0, 1),Color3.new(0.831373, 0, 1)),
        InnerStroke = ColorSequence.new(Color3.new(0.803922, 0.564706, 1),Color3.new(0.984314, 0.52549, 1)),
        Bottom = Color3.new(0.380392, 0.094118, 0.65098),
        OuterStroke = Color3.new(0.137255, 0, 0.270588),
    },
    Red = {
        Main = ColorSequence.new(Color3.new(1, 0.121569, 0.164706),Color3.new(1, 0, 0.584314)),
        InnerStroke = ColorSequence.new(Color3.new(1, 0.356863, 0.439216),Color3.new(1, 0.466667, 0.823529)),
        Bottom = Color3.new(0.686275, 0.062745, 0.062745),
        OuterStroke = Color3.new(0.270588, 0, 0),
    },
    Gold = {
        Main = ColorSequence.new(Color3.new(1, 0.2, 0),Color3.new(1, 0.901961, 0)),
        InnerStroke = ColorSequence.new(Color3.new(1, 0.411765, 0.368627),Color3.new(0.992157, 1, 0.607843)),
        Bottom = Color3.new(0.752941, 0.211765, 0),
        OuterStroke = Color3.new(0.239216, 0.027451, 0),
    },
}

type props = {
    Name: string?,
    Color: "Blue" | "Green" | "Purple" | "Red" | "Gold",
    Visible: boolean?,
    LayoutOrder: number?,
    Size: UDim2?,
    Rotation: number?,
    AnchorPoint: Vector2?,
    BackgroundTransparency: number?,
    Position: UDim2?,
    Activated: (()->())?,
    MouseEnter: (()->())?,
    MouseLeave: (()->())?,
    MouseButton1Down: (()->())?,
    MouseButton1Up: (()->())?,
    Children: {}?,
}

local create = vide.create

return function(props:props)
    local children = {
        create "UIStroke" {
            Thickness = 4,
            BorderStrokePosition = Enum.BorderStrokePosition.Outer,
            Color = COLORS[props.Color].OuterStroke
        },
        create "Frame" {
            Size = UDim2.new(1,0,1,-5),
            AnchorPoint = Vector2.new(0.5,0),
            Position = UDim2.fromScale(0.5,0),
            create "ImageLabel" {
                Name = "Studs",
                Size = UDim2.fromScale(1, 1),
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2.fromOffset(125, 125),
                Image = ImageIds.Shared.Studs,
                BackgroundTransparency = 1,
            },
            create "UIGradient" {
                Color = COLORS[props.Color].Main,
                Rotation = -90
            },
            create "UIStroke" {
                Thickness = 4,
                BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                Color = Color3.new(1,1,1),
                create "UIGradient" {
                    Color = COLORS[props.Color].InnerStroke,
                    Rotation = -90
                },
            },
        }
    }
    if props.Children then
        for _, v in props.Children do
            table.insert(children, v)
        end
    end
    return AnimatedButton {
        Name = props.Name,
        Visible = props.Visible,
        LayoutOrder = props.LayoutOrder,
        Size = props.Size,
        Rotation = props.Rotation,
        BackgroundTransparency = 0,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        BackgroundColor3 = COLORS[props.Color].Bottom,
        Activated = props.Activated,
        Children = children
    }
end
