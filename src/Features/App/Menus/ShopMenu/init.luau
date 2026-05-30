local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerLuck = require(script.components.ServerLuck)
local vide = require(ReplicatedStorage.Packages.vide)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local Frame = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.Frame)
local CenterFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.CenterFrame)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source
local create = vide.create

local MENU = "Shop"

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
        Size = UDim2.fromOffset(1000, 600),
        TopY = 86,
        Icon = ImageIds.Icons.Shop,
        Visible = visible,
        MainBarColor = "Gold",
        Children = {
            Frame {
                Name = "Items",
                Size = UDim2.fromScale(1, 1),
                Children = {
                    create "UIListLayout" {
                        Padding = UDim.new(0, 20),
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        FillDirection = Enum.FillDirection.Vertical,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    },
                    create "UIPadding" {
                        PaddingTop = UDim.new(0, 20),
                    },
                    ServerLuck(),
                }
            }
        }
    }
end
