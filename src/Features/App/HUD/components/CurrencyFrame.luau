local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local FormatNumber = require(ReplicatedStorage.Shared.Modular.Math.FormatNumber)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)
local StudImage = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudImage)
type props = {
    Currency: string,
    Image:string,
    BackgroundColor:string,
    Amount:vide.Source<number>,
}

return function(props:props)

    return StudImage {
        Name = props.Currency,
        Size = UDim2.fromOffset(255, 87),
        Color = props.BackgroundColor,
        Children = {
            ImageLabel {
                Name = "Icon",
                Size = UDim2.fromOffset(87, 87),
                Image = props.Image,
                AnchorPoint = Vector2.new(0,0.5),
                Position = UDim2.fromScale(0, 0.5),
            },
            TextLabel {
                Size = UDim2.new(1, -100, 0, 74),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.fromScale(1, 0.5),
                Text = function()
                    return FormatNumber(math.round(props.Amount()))
                end,
                StrokeThickness = 4,
                TextXAlignment = Enum.TextXAlignment.Left,
            }
        }
    }
end
