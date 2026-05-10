local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local FunnelServiceClient = require(ReplicatedStorage.Shared.Modular.Services.FunnelService.FunnelServiceClient)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local Gradients = require(ReplicatedStorage.Shared.Modular.UI.Modules.Gradients)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source
local create = vide.create

type props = {
    Spins: number,
    ProductId: number,
}
return function(props:props)
    local price = source(0)
    task.spawn(function()
        local cost = MonitizationServiceClient:getProductPrice(props.ProductId)
        price(cost)
    end)
    return StudButton {
        Name = `{props.Spins} Spins`,
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.fromOffset(250, 75),
        Color = "Purple",
        LayoutOrder = props.Spins,
        Activated = function()
            FunnelServiceClient:stepCompleted(AppConstants.FUNNELS.PURCHASE_SPIN, 3, "Prompted")
            MonitizationServiceClient:promptProduct(props.ProductId)
        end,
        Children = {
            TextLabel {
                Name = "MainText",
                Size = UDim2.fromScale(0.9, 0.9),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Text = if props.Spins > 1 then `+{props.Spins} Spins` else "+1 Spin",
                StrokeThickness = 3,
            },
            TextLabel {
                Name = "Cost",
                Size = UDim2.fromScale(0.7, 0.45),
                AnchorPoint = Vector2.new(.9,0.75),
                Position = UDim2.fromScale(1, 1),
                Text = function()
                    return `{ImageIds.Icons.Robux}{price()}`
                end,
                TextXAlignment = Enum.TextXAlignment.Right,
                StrokeThickness = 3,
                Children = {
                    create "UIGradient" {
                        Color = Gradients.Cash,
                        Rotation = -90
                    }
                }
            }
        }
    }
end
