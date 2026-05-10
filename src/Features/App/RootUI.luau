local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Boosts = require(ReplicatedStorage.Shared.Features.App.HUD.Boosts)
local LeftSideBar = require(ReplicatedStorage.Shared.Features.App.HUD.LeftSideBar)
local NitroBar = require(ReplicatedStorage.Shared.Features.App.HUD.NitroBar)
local NitroBoost = require(ReplicatedStorage.Shared.Features.App.HUD.NitroBoost)
local RightSideBar = require(ReplicatedStorage.Shared.Features.App.HUD.RightSideBar)
local RightSideMonitization = require(ReplicatedStorage.Shared.Features.App.HUD.RightSideMonitization)
local RebirthMenu = require(ReplicatedStorage.Shared.Features.App.Menus.RebirthMenu)
local RewardsMenu = require(ReplicatedStorage.Shared.Features.App.Menus.RewardsMenu)
local StarterPackMenu = require(ReplicatedStorage.Shared.Features.App.Menus.StarterPackMenu)
local WheelMenu = require(ReplicatedStorage.Shared.Features.App.Menus.WheelMenu)

local root = vide.root
local create =  vide.create

return function()
    return root(function()  
        return create "ScreenGui" {
            Name = "App",
            IgnoreGuiInset = true,
            Parent = Players.LocalPlayer.PlayerGui,
            LeftSideBar(),
            RightSideBar(),
            RightSideMonitization(),
            Boosts(),
            NitroBar(),
            NitroBoost(),

            RebirthMenu(),
            RewardsMenu(),
            StarterPackMenu(),
            WheelMenu(),
            
        }
    end)
end
