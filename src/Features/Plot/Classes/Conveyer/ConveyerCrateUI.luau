local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local FormatNumber = require(ReplicatedStorage.Shared.Modular.Math.FormatNumber)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
local create = vide.create

return function(crateInfo:DataTemplate.CrateInfo)

    return create "BillboardGui" {
        Name = "CrateUI",
        Size = UDim2.fromScale(7, 4),
        create "UIListLayout" {
            Padding = UDim.new(.05,0),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Vertical,
        },
        TextLabel {
            Name = "CrateName",
            Size = UDim2.fromScale(1, 0.3),
            StrokeThickness = 3,
            Text = crateInfo.Name,
            LayoutOrder = 1,
        },
        TextLabel {
            Name = "Rarity",
            Size = UDim2.fromScale(1, 0.2),
            StrokeThickness = 3,
            Text = Crates[crateInfo.Name].Rarity,
            LayoutOrder = 2,
            Children = {
                create "UIGradient" {
                    Color = Gradients[Crates[crateInfo.Name].Rarity],
                    Rotation = -90,
                }
            }
        },
        TextLabel {
            Name = "Cost",
            Size = UDim2.fromScale(1, 0.2),
            StrokeThickness = 3,
            Text = `${FormatNumber(Crates[crateInfo.Name].Cost)}`,
            LayoutOrder = 2,
            Children = {
                create "UIGradient" {
                    Color = Gradients.Cash,
                    Rotation = -90,
                }
            }
        },
    }
end
