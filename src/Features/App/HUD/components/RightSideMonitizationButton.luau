local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AnimatedButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.AnimatedButton)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
type props = {
    Name: string,
    Icon: string,
    TopText: string,
    CenterText: (string | () -> string)?,
    BottomText: string,
    Activated: (()->()),
}

local create = vide.create

return function(props:props)
    return AnimatedButton {
        Name = props.Name,
        Size = UDim2.fromOffset(150, 150),
        AnchorPoint = Vector2.new(0.5,0.5),
        Activated = props.Activated,
        Children = {
            Frame {
                Name = "Background",
                Size = UDim2.fromScale(1, 1),
                
                Children = {
                    create "UICorner" {
                        CornerRadius = UDim.new(1,0),
                    },
                    create "UIStroke" {
                        Thickness = 6,
                        Transparency = 0.7,
                    },
                    Frame {
                        Name = "Background",
                        Size = UDim2.fromScale(.9, .9),
                        BackgroundTransparency = 0.7,
                        BackgroundColor3 = Color3.new(),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Children = {
                            create "UICorner" {
                                CornerRadius = UDim.new(1,0),
                            },
                        }
                    },
                    ImageLabel {
                        Name = "Icon",
                        Image = props.Icon,
                        Size = UDim2.fromScale(0.9, 0.9),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5,0.5),
                    },
                    TextLabel {
                        Name = "TopText",
                        Size = UDim2.fromScale(0.9, 0.3),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 0),
                        StrokeThickness = 3,
                        Text = props.TopText,
                        Children = {
                            create "UIGradient" {
                                Color = Gradients.Rainbow,
                            }
                        }
                    },
                    TextLabel {
                        Name = "BottomText",
                        Size = UDim2.fromScale(0.9, 0.3),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 1),
                        StrokeThickness = 3,
                        Text = props.BottomText,
                    },
                    TextLabel {
                        Name = "CenterText",
                        Size = UDim2.fromScale(0.9, 0.2),
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        StrokeThickness = 3,
                        Text = props.CenterText,
                    }
                }
            }
        }
    }
end
