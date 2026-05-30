local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local AppClient = require(ReplicatedStorage.Shared.Features.App.AppClient)
local RootUI = require(ReplicatedStorage.Shared.Features.App.RootUI)
local InventoryClient = require(ReplicatedStorage.Shared.Features.Inventory.InventoryClient)
local PlotClient = require(ReplicatedStorage.Shared.Features.Plot.PlotClient)
local RebirthClient = require(ReplicatedStorage.Shared.Features.Rebirth.RebirthClient)
local TutorialClient = require(ReplicatedStorage.Shared.Features.Tutorial.TutorialClient)
local UpgradesClient = require(ReplicatedStorage.Shared.Features.Upgrades.UpgradesClient)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local ProxPromptServiceClient = require(ReplicatedStorage.Shared.Modular.Services.ProxPromptService.ProxPromptServiceClient)

RootUI()

dataservice:init()

-- MODULAR --
MonitizationServiceClient:init()
ProxPromptServiceClient:init()


-- FEATURES --
AppClient:init()
InventoryClient:init()
PlotClient:init()
UpgradesClient:init()
RebirthClient:init()

TutorialClient:init()