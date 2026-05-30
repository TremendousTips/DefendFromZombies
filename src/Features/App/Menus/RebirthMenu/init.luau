local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local RebirthSlice = require(ReplicatedStorage.Shared.Features.Rebirth.RebirthSlice)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local CenterFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.CenterFrame)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local StudImage = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudImage)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source
local create = vide.create

local MENU = "Rebirth"

return function()
    local visible = source(false)
    AppSlice.openMenu:Connect(function(menu: string)
        if MENU == menu then
            visible(not visible())
        else
            visible(false)
        end
    end)
    
    return CenterFrame {
        Name = MENU,
        MainBarColor = "Red",
        Visible = visible,
        Icon = ImageIds.Icons.Rebirth,
        Size = UDim2.fromOffset(747, 572),
        TopY = 84,
        Closed = function()
        end,
        Children = {
            TextLabel({
                Name = "NeedText",
                Size = UDim2.fromOffset(312, 70),
                AnchorPoint = Vector2.new(0.5,0),
                TextYAlignment = Enum.TextYAlignment.Top,
                Position = UDim2.new(0.5, 0, 0, 5),
                StrokeThickness = 3,
                Text = `-YOU NEED-`
            }),
            StudImage {
                Name = "NeedFrame",
                Size = UDim2.fromOffset(672, 158),
                AnchorPoint = Vector2.new(0.5,0),
                Position = UDim2.new(0.5,0,0,72),
                Color = "Gold",
            },
            TextLabel({
                Name = "RecieveText",
                Size = UDim2.fromOffset(312, 70),
                AnchorPoint = Vector2.new(0.5,0),
                TextYAlignment = Enum.TextYAlignment.Top,
                Position = UDim2.new(0.5, 0, 0, 239),
                StrokeThickness = 3,
                Text = `-YOU RECIEVE-`,
                Children = {
                    create "UIGradient" {
                        Color = Gradients.Golden,
                        Rotation = -90,
                    }
                }
            }),
            StudImage {
                Name = "RecieveFrame",
                Size = UDim2.fromOffset(672, 158),
                AnchorPoint = Vector2.new(0.5,0),
                Position = UDim2.new(0.5,0,0,297),
                Color = "Gold",
            },
            StudButton {
                Name = "RebirthButton",
                Size = UDim2.fromOffset(238, 80),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0,509),
                Color = "Green",
                Activated = function()
                    RebirthSlice.attemptRebirth:Fire()
                end,
                Children = {
                    TextLabel {
                        Name = "Text",
                        Size = UDim2.fromScale(0.9, 0.9),
                        Text = "Rebirth!",
                        StrokeThickness = 3,
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Position = UDim2.fromScale(0.5, 0.5)
                    }
                }
            },
            TextLabel({
                Size = UDim2.fromScale(0.8, 0.15),
                AnchorPoint = Vector2.new(0.5,0),
                Position = UDim2.fromScale(0.5, 1),
                StrokeThickness = 3,
                RichText = true,
                Text = `<font color="rgb(255,230,0)">WARNING!</font> You ONLY LOSE your <font color="rgb(0,255,50)">CASH</font> but you will keep your towers!`
            })
        }
    }
end
