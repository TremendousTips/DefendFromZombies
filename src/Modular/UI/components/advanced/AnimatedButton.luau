local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(script.Parent.Parent.Foundational.Button)

local source = vide.source
local spring = vide.spring

export type props = {
    Name: string?,
    Image: string?,
    Visible: boolean?,
    LayoutOrder: number?,
    Size: UDim2?,
    Rotation: number?,
    AnchorPoint: Vector2?,
    BackgroundTransparency: number?,
    Position: UDim2?,
    BackgroundColor3: Color3?,
    Activated: (()->())?,
    MouseEnter: (()->())?,
    MouseLeave: (()->())?,
    MouseButton1Down: (()->())?,
    MouseButton1Up: (()->())?,
    Children: {}?,
}

local SCALE = 1.1
local SHRINK = 0.9

return function(props:props)
    local sourceSize = source(props.Size)
    local springSize = spring(sourceSize, 0.2, 0.75)

    local X = props.Size.X.Offset
    local Y = props.Size.Y.Offset

    return Button {
        Name = props.Name,
        Image = props.Image,
        Visible = props.Visible,
        LayoutOrder = props.LayoutOrder,
        Size = springSize,
        Rotation = props.Rotation,
        AnchorPoint = props.AnchorPoint,
        BackgroundTransparency = props.BackgroundTransparency or 1,
        Position = props.Position,
        BackgroundColor3 = props.BackgroundColor3,
        Activated = props.Activated,
        MouseEnter = function()
            sourceSize(UDim2.fromOffset(X*SCALE, Y*SCALE))
        end,
        MouseLeave = function()
            sourceSize(props.Size)
        end,
        MouseButton1Down = function()
            sourceSize(UDim2.fromOffset(X*SHRINK, Y*SHRINK)) 
        end,
        MouseButton1Up = function()
            sourceSize(UDim2.fromOffset(X*SCALE, Y*SCALE))
        end,
        Children = props.Children,
    }
end
