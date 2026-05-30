local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)
type props = {
    IsGamepass: boolean,
    Id: number | vide.Source<number>,
    Size: UDim2,
    AnchorPoint: Vector2,
    Position: UDim2,
    Color: string?,
}

local source = vide.source

local effect = vide.effect

return function(props:props)
    local cost = source(0)
    local owned = source(false)

    local id = props.Id

    if type(props.Id) == type(1) then
        id = source(props.Id)
    end


    effect(function()
        if props.IsGamepass then
            cost(MonitizationServiceClient:getGamepassPrice(id()))
            owned(MonitizationServiceClient:ownsGamepass(id()))
        else
            cost(MonitizationServiceClient:getProductPrice(id()))
        end
    end)

    return StudButton {
        Name = props.Id,
        Size = props.Size,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Color = props.Color or "Green",
        Activated = function()
            if props.IsGamepass then
                MonitizationServiceClient:promptPass(id())
            else
                MonitizationServiceClient:promptProduct(id())
            end
        end,
        Children = {
            TextLabel {
                Name = "Text",
                Size = UDim2.fromScale(0.9, 0.9),
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                StrokeThickness = 3,
                Text = function()
                    if owned() then
                        return "Owned"
                    else
                        return `{ImageIds.Icons.Robux}{cost()}`
                    end
                end
            }
        }
    }
end
