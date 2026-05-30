local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShopEnums = require(ReplicatedStorage.Shared.Features.App.Menus.ShopMenu.ShopEnums)
local RobuxButton = require(ReplicatedStorage.Shared.Features.App.Menus.ShopMenu.components.RobuxButton)
local ShopSlice = require(ReplicatedStorage.Shared.Features.Shop.ShopSlice)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local StudImage = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudImage)

return function()
    return StudImage {
        Name = "ServerLuck",
        Color = "Green",
        Size = UDim2.fromOffset(ShopEnums.ItemX, 225),
        AnchorPoint = Vector2.new(0.5,0.5),
        Children = {
            TextLabel {
                Name = "Label",
                Size = UDim2.fromScale(0.4, 0.25),
                Position = UDim2.fromOffset(15, 5),
                AnchorPoint = Vector2.new(0,0),
                TextXAlignment = Enum.TextXAlignment.Left,
                StrokeThickness = 3,
                Text = "Server Luck",
            },
            RobuxButton {
                Id = ShopSlice.serverLuckProductId,
                Size = UDim2.fromOffset(200, 65),
                AnchorPoint = Vector2.new(1,1),
                Position = UDim2.new(1,-15,1,-15),
                Color = "Purple",
            }
        }
    }
end
