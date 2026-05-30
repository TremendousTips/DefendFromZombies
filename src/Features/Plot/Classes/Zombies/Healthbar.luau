local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local FormatNumber = require(ReplicatedStorage.Shared.Modular.Math.FormatNumber)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
type props = {
    Health: vide.Source<number>,
    MaxHealth: number,
}

local create = vide.create
local spring = vide.spring
local source = vide.source
local effect = vide.effect

return function(props:props)
    local sizeSource = source(UDim2.fromScale(1, 1))
    local sizeSpring = spring(sizeSource, 0.2, 0.8)
    local textSource = source(`{FormatNumber(props.Health())}/{FormatNumber(props.MaxHealth)}`)

    effect(function()
        sizeSource(UDim2.fromScale(math.max(props.Health()/props.MaxHealth, 0), 1))
        textSource(`{FormatNumber(props.Health())}/{FormatNumber(props.MaxHealth)}`)
    end)

    return create "BillboardGui" {
        Name = "Healthbar",
        Size = UDim2.fromScale(4, .75),
        SizeOffset = Vector2.new(0, 1),
        Frame {
            Name = "Background",
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 0,
            Children = {
                create "UIGradient" {
                    Color = Gradients.Bloodlit,
                    Rotation = -90
                },
                create "UIStroke" {
                    Thickness = 2,
                    BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                },
                create "UICorner" {
                    CornerRadius = UDim.new(1,0)
                    
                },
                
                Frame {
                    Name = "Green",
                    Size = sizeSpring,
                    BackgroundTransparency = 0,
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.fromScale(0, 0.5),
                    Children = {
                        create "UIGradient" {
                            Color = Gradients.Cash,
                            Rotation = -90
                        },
                        create "UIStroke" {
                            Thickness = 2,
                            BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                        },
                        create "UICorner" {
                            CornerRadius = UDim.new(1,0)
                        }
                    },
                },
                TextLabel {
                    Name = "Health",
                    Text = textSource,
                    Size = UDim2.fromScale(0.6, 0.8),
                    AnchorPoint = Vector2.new(0.5,0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    StrokeThickness = 2,
                },
            },
        }
    }
end
