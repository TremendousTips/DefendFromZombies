local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
local vide = require(ReplicatedStorage.Packages.vide)
local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local FormatTime = require(ReplicatedStorage.Shared.Modular.UI.Modules.FormatTime)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
type props = {
    Parent: Instance,
    CrateInfo: DataTemplate.CrateInfo,
    TimeLeft: charm.Atom<number>,
}

local create = vide.create
local source = vide.source

local subscribe = charm.subscribe

return function(props:props)
    local timeDisplay = source("0:00")

    subscribe(props.TimeLeft, function(state:number)  
        if state > 0 then
            timeDisplay(FormatTime(state))
        else
            timeDisplay("Ready!")
        end
    end)

    return create "BillboardGui" {
        Name = "CrateUI",
        Size = UDim2.fromScale(5, 4),
        Parent = props.Parent,
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
            Text = props.CrateInfo.Name,
            LayoutOrder = 1,
        },
        TextLabel {
            Name = "Rarity",
            Size = UDim2.fromScale(1, 0.2),
            StrokeThickness = 3,
            Text = Crates[props.CrateInfo.Name].Rarity,
            LayoutOrder = 2,
            Children = {
                create "UIGradient" {
                    Color = Gradients[Crates[props.CrateInfo.Name].Rarity],
                    Rotation = -90,
                }
            }
        },
        TextLabel {
            Name = "TimeLeft",
            Size = UDim2.fromScale(1, 0.15),
            StrokeThickness = 3,
            LayoutOrder = 3,
            Text = timeDisplay,

        }
    }
end
