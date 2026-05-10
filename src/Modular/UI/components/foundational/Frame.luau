local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
type props = {
    Name: string,
    Size: UDim2?,
    AnchorPoint: Vector2?,
    BackgroundColor3: Color3?,
    Position: UDim2?,
    BackgroundTransparency: number?,
    Visible: boolean?,
    Rotation: number?,
    LayoutOrder: number?,
    ZIndex: number?,
    Children: {}?,
}

local create = vide.create

return function(props:props)
    return create "Frame" {
        Name = props.Name,
        Size = props.Size,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Visible = props.Visible,
        LayoutOrder = props.LayoutOrder,
        Rotation = props.Rotation,
        BackgroundColor3 = props.BackgroundColor3,
        ZIndex = props.ZIndex,
        BackgroundTransparency = props.BackgroundTransparency or 1,
        props.Children,
    }
end
