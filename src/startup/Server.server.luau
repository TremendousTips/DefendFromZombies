local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local InventoryServer = require(ServerScriptService.Features.Inventory.InventoryServer)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local PlotServer = require(ServerScriptService.Features.Plot.PlotServer)
local RebirthServer = require(ServerScriptService.Features.Rebirth.RebirthServer)
local TutorialServer = require(ServerScriptService.Features.Tutorial.TutorialServer)
local UpgradesServer = require(ServerScriptService.Features.Upgrades.UpgradesServer)
local BoostServiceServer = require(ServerScriptService.Modular.Services.BoostService.BoostServiceServer)
local ItemServiceServer = require(ServerScriptService.Modular.Services.ItemService.ItemServiceServer)
local MonitizationServiceServer = require(ServerScriptService.Modular.Services.MonitizationService.MonitizationServiceServer)

function dataservice:onPlayerInit(player:Player, data:DataTemplate.data)
    -- MODULAR --
    MonitizationServiceServer:playerAdded(player, data)
    BoostServiceServer:playerAdded(player, data)


    -- FEATURES --
    PlotServer:playerAdded(player, data)
    InventoryServer:playerAdded(player, data)
end

dataservice:addPlayerRemovingCallback(function(player: Player, data)
    -- FEATURES --
    PlotServer:playerRemoved(player, data)
    InventoryServer:playerRemoved(player)

    -- MODULAR --
    BoostServiceServer:playerRemoved(player, data)
end)

dataservice:init({
    template = DataTemplate,
    profileStoreIndex = "Testing",
    useMock = true
})

-- MODULAR --
MonitizationServiceServer:init()
ItemServiceServer:init()
BoostServiceServer:init()

-- FEATURES --
InventoryServer:init()
PlotServer:init()
UpgradesServer:init()
RebirthServer:init()

TutorialServer:init()