local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local StudImage = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudImage)

type props = {
    Name: string,
    Icon: string,
    BackgroundColor: string,
    Activated: (()->()),
    Notification: vide.Source<boolean>,
}

return function(props:props)
    return StudButton {
        Name = props.Name,
        Size = UDim2.fromOffset(100, 110),
        Color = props.BackgroundColor,
        Activated = props.Activated,
        Children = {
            ImageLabel {
                Name = "Icon",
                Size = UDim2.fromScale(1, 10/11),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Image = props.Icon,
            },
            TextLabel {
                Name = "Label",
                Size = UDim2.fromScale(0.95, 0.25),
                Text = props.Name,
                StrokeThickness = 3,
                AnchorPoint = Vector2.new(0.5,0.6),
                Position = UDim2.fromScale(0.5, 1),
            },
            StudImage {
                Name = "Notification",
                Size = UDim2.fromOffset(30, 35),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(1, 0),
                Color = "Red",
                Visible = props.Notification or false,
                Children = {
                    TextLabel {
                        Name = "!",
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromScale(1, 1),
                        Text = "!",
                        StrokeThickness = 3,
                    }
                }
            }
        }
    }
end
