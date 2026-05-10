local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AppClient = require(ReplicatedStorage.Shared.Features.App.AppClient)
local RootUI = require(ReplicatedStorage.Shared.Features.App.RootUI)
local ArrowClient = require(ReplicatedStorage.Shared.Features.Arrow.ArrowClient)
local FriendsClient = require(ReplicatedStorage.Shared.Features.Friends.FriendsClient)
local PlotClient = require(ReplicatedStorage.Shared.Features.Plot.PlotClient)
local RebirthClient = require(ReplicatedStorage.Shared.Features.Rebirth.RebirthClient)
local RewardsClient = require(ReplicatedStorage.Shared.Features.Rewards.RewardsClient)
local SwingingClient = require(ReplicatedStorage.Shared.Features.Swinging.SwingingClient)
local TrailsClient = require(ReplicatedStorage.Shared.Features.Trails.TrailsClient)
local UpgradesClient = require(ReplicatedStorage.Shared.Features.Upgrades.UpgradesClient)
local WheelClient = require(ReplicatedStorage.Shared.Features.Wheel.WheelClient)
local BoostServiceClient = require(ReplicatedStorage.Shared.Modular.Services.BoostService.BoostServiceClient)
local CameraServiceClient = require(ReplicatedStorage.Shared.Modular.Services.CameraService.CameraServiceClient)
local FunnelServiceClient = require(ReplicatedStorage.Shared.Modular.Services.FunnelService.FunnelServiceClient)
local ItemServiceClient = require(ReplicatedStorage.Shared.Modular.Services.ItemService.ItemServiceClient)
local MonitizationServiceClient = require(ReplicatedStorage.Shared.Modular.Services.MonitizationService.MonitizationServiceClient)
local SoundServiceClient = require(ReplicatedStorage.Shared.Modular.Services.SoundService.SoundServiceClient)

local dataservice = require(ReplicatedStorage.Packages.dataservice).client

dataservice:init()
RootUI()

-- MODULAR --
FunnelServiceClient:init()
CameraServiceClient:init()
SoundServiceClient:init()
ItemServiceClient:init()
MonitizationServiceClient:init()
BoostServiceClient:init()

-- FEATURES --
AppClient:init()
PlotClient:init()
UpgradesClient:init()
SwingingClient:init()
RebirthClient:init()
RewardsClient:init()
WheelClient:init()
ArrowClient:init()
FriendsClient:init()
TrailsClient:init()