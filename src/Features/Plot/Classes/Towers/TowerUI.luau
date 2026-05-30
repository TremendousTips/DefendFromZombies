local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)

local create = vide.create

return function(towerInfo:DataTemplate.TowerInfo)
    return create "BillboardGui" {
        Name = "TowerUI",
        Size = UDim2.fromScale(5, 5),
        SizeOffset = Vector2.new(0, .6),
        create "UIListLayout" {
            Padding = UDim.new(0.1,0),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
        },
        TextLabel {
            Name = "Name",
            Size = UDim2.fromScale(1, 0.3),
            Text = towerInfo.Name,
            StrokeThickness = 3,
        },
        TextLabel {
            Name = "Rarity",
            Size = UDim2.fromScale(1, 0.2),
            StrokeThickness = 3,
            Text = Towers[towerInfo.Name].Rarity,
            LayoutOrder = 2,
            Children = {
                create "UIGradient" {
                    Color = Gradients[Towers[towerInfo.Name].Rarity],
                    Rotation = -90,
                }
            }
        },
    }
end
