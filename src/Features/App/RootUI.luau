local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Currency = require(ReplicatedStorage.Shared.Features.App.HUD.Currency)
local LeftSideBar = require(ReplicatedStorage.Shared.Features.App.HUD.LeftSideBar)
local Overlay = require(ReplicatedStorage.Shared.Features.App.Menus.Overlay)
local RebirthMenu = require(ReplicatedStorage.Shared.Features.App.Menus.RebirthMenu)
local ShopMenu = require(ReplicatedStorage.Shared.Features.App.Menus.ShopMenu)


local root = vide.root
local create =  vide.create

return function()
    return root(function()  
        return create "ScreenGui" {
            Name = "App",
            IgnoreGuiInset = true,
            Parent = Players.LocalPlayer.PlayerGui,
            LeftSideBar(),
            Currency(),

            ShopMenu(),
            RebirthMenu(),
            Overlay(),
        }
    end)
end
