local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local camera = workspace.CurrentCamera

local source = vide.source

local viewportSize = source(camera.ViewportSize)

return function()
    viewportSize(camera.ViewportSize)
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()  
        viewportSize(camera.ViewportSize)
    end)

    return viewportSize
end