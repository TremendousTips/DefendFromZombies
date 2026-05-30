local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
type props = {
    Model:Model, 
    Activated:(()->())
}

local root = vide.root
local source = vide.source
local spring = vide.spring
local effect = vide.effect

local player = Players.LocalPlayer

return function(props:props)
    root(function()
        local offsetSource = source(0)
        local offsetSpring = spring(offsetSource, 0.2, 0.6)

        local main = props.Model.Main :: Part

        effect(function()
            main.Position = (props.Model.PrimaryPart.Position + Vector3.new(0,0.2,0)) - Vector3.new(0, offsetSpring(), 0)
        end)

        local db = false
        main.Touched:Connect(function(toucher: BasePart)
            if toucher:IsDescendantOf(player.Character) and not db then
                db = true
                props.Activated()
                offsetSource(.1)
                task.wait(0.2)
                offsetSource(0)
                task.wait(0.3)
                db = false
            end
        end)
    end)   

end
