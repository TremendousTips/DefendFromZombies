local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local ShopMenu = require(ReplicatedStorage.Shared.Features.App.Menus.ShopMenu)
local root = vide.root
local create =  vide.create

return function(target)
    return root(function(destroy:()->())  
        local screen = create "ScreenGui" {
            Name = "App",
            IgnoreGuiInset = true,
            Parent = target,

            ShopMenu(),
            
        }
        function destroy()
            screen:Destroy()
        end
    end)
end
