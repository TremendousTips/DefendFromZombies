local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)
local StudImage = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudImage)
type props = {
    Icon: string,
    Text: string,
}

return function(props:props)
    return StudImage {
        Size = UDim2.fromOffset(150, 150),
        AnchorPoint = Vector2.new(0.5,0.5),
        Color = "Gold",
        Children = {
            ImageLabel {
                Name = "Icon",
                Size = UDim2.fromScale(0.9,0.9),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Image = props.Icon,
            },
            TextLabel {
                Name = "BottomText",
                Text = props.Text,
                StrokeThickness = 3,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromScale(0.8, 0.3),
            }
        }
    }
end
