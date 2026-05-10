local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create

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

return function(props:props)
    return create "ImageButton" {
        Name = props.Name,
        Image = props.Image,
        Visible = props.Visible,
        LayoutOrder = props.LayoutOrder,
        Size = props.Size,
        Rotation = props.Rotation,
        AnchorPoint = props.AnchorPoint,
        BackgroundTransparency = props.BackgroundTransparency or 1,
        Position = props.Position,
        BackgroundColor3 = props.BackgroundColor3,
        Activated = props.Activated,
        MouseEnter = props.MouseEnter,
        MouseLeave = props.MouseLeave,
        MouseButton1Down = props.MouseButton1Down,
        MouseButton1Up = props.MouseButton1Up,
        props.Children,
    }
end
