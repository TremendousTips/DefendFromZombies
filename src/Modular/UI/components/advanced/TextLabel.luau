local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create

local preset = {
    Font = Enum.Font.BuilderSansExtraBold,
    Size = UDim2.fromOffset(200, 50),
    AnchorPoint = Vector2.new(0.5,0.5),
    StrokeColor = Color3.new(0,0,0),
    TextColor = Color3.new(1,1,1),
}

type props = {
    Name: string?,
    Size: UDim2?,
    AnchorPoint: Vector2?,
    Visible: boolean?,
    BackgroundTransparency: number?,
    Parent: Instance?,
    Text: string?,
    TextScaled: boolean?,
    TextSize: number?,
    LayoutOrder: number?,
    TextBoundsChanged: (()->())?,
    TextTransparency: number?,
    Position: UDim2?,
    TextColor3: Color3?,
    TextXAlignment: Enum.TextXAlignment?,
    TextYAlignment: Enum.TextYAlignment?,
    StrokeThickness: number?,
    StrokeColor: Color3?,
    StrokeSizingMode: Enum.StrokeSizingMode?,
    RichText: boolean?,
    Rotation: number?,
    AutomaticSize: Enum.AutomaticSize?,
    Children: {}?,
}

return function(props:props)

    local textScaled = true

    if props.TextSize then
        textScaled = false
    end

    if (props.StrokeThickness or 0) > 0 then
        local stroke = create "UIStroke" {
            Thickness = props.StrokeThickness,
            Color = props.StrokeColor or preset.StrokeColor,
            StrokeSizingMode = props.StrokeSizingMode,
        }
        if not props.Children then
            props.Children = {}
        end
        table.insert(props.Children, stroke)
    end

    return create "TextLabel" {
        Name = props.Name,
        Size = props.Size or preset.Size,
        Parent = props.Parent,
        AnchorPoint = props.AnchorPoint or preset.AnchorPoint,
        BackgroundTransparency = props.BackgroundTransparency or 1,
        Text = props.Text,
        Font = preset.Font,
        Visible = props.Visible,
        Rotation = props.Rotation,
        TextScaled = textScaled,
        TextSize = props.TextSize,
        TextTransparency = props.TextTransparency,
        TextColor3 = props.TextColor3 or preset.TextColor,
        Position = props.Position,
        LayoutOrder = props.LayoutOrder,
        TextXAlignment = props.TextXAlignment,
        TextYAlignment = props.TextYAlignment,
        AutomaticSize = props.AutomaticSize,
        RichText = props.RichText,
        props.Children
    }
end