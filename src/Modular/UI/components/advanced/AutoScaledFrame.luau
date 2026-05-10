local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Frame = require(script.Parent.Parent.Foundational.Frame)
local useViewportSize = require(script.Parent.Parent.Parent.Hooks.useViewportSize)

local create = vide.create

type props = {
    Name: string,
    Size: UDim2?,
    AnchorPoint: Vector2?,
    BackgroundColor3: Color3?,
    Position: UDim2?,
    BackgroundTransparency: number?,
    Visible: boolean?,
    LayoutOrder: number?,
    ZIndex: number?,
    Children: {}?,
}

local X = 1600
local Y = 800

return function(props:props)
    props.Children = props.Children or {}
    
    local UIScale = create "UIScale" {
        Scale = function()
            local viewportSize = useViewportSize()()
            local screenScale = Vector2.new(viewportSize.X/X, viewportSize.Y/Y)
            local size = math.min(1*screenScale.X, 1*screenScale.Y)
            return math.min(size, 1)
        end
    }
    
    table.insert(props.Children, UIScale)

    return Frame {
        Name = props.Name,
        Size = props.Size,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Visible = props.Visible,
        LayoutOrder = props.LayoutOrder,
        BackgroundColor3 = props.BackgroundColor3,
        ZIndex = props.ZIndex,
        BackgroundTransparency = props.BackgroundTransparency or 1,
        Children = props.Children,
    }
end