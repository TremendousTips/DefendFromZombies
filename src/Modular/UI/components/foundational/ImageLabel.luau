local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create

type props = {
    Name: string?,
    Size: UDim2?,
    AnchorPoint: Vector2?,
    BackgroundTransparency: number?,
    ImageTransparency: number?,
    ImageColor3: Color3?,
    ClipsDescendants: boolean?,
    BackgroundColor3: Color3?,
    SizeConstraint: Enum.SizeConstraint?,
    Visible: boolean?,
    Position: UDim2?,
    Rotation: number?,
    Image: string?,
    LayoutOrder: number,
    Children: {},
}

return function(props:props)
    return create "ImageLabel" {
        Name = props.Name,
        Size = props.Size,
        AnchorPoint = props.AnchorPoint,
        BackgroundTransparency = props.BackgroundTransparency or 1,
        ImageTransparency = props.ImageTransparency,
        BackgroundColor3 = props.BackgroundColor3,
        SizeConstraint = props.SizeConstraint,
        Visible = props.Visible,
        ClipsDescendants = props.ClipsDescendants,
        Position = props.Position,
        ImageColor3 = props.ImageColor3,
        Rotation = props.Rotation,
        Image = props.Image,
        LayoutOrder = props.LayoutOrder,
        props.Children
    }
end