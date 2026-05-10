local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimatedButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AnimatedButton)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)

type props = {
    Icon: string,
    Label: string,
    Text: string | () -> string,
    Activated: (()->()),
}

return function(props:props)
    return AnimatedButton {
        Name = props.Label,
        Image = props.Icon,
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.fromOffset(80,80),
        Activated = props.Activated,
        Children = {
            TextLabel {
                Name = "Text",
                Size = UDim2.fromScale(0.9, 0.3),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 1),
                Text = props.Text,
                StrokeThickness = 3,
            }
        }
    }
end
