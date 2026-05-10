local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local AppServer = require(ServerScriptService.Features.App.AppServer)
local FriendsServer = require(ServerScriptService.Features.Friends.FriendsServer)
local LeaderboardServer = require(ServerScriptService.Features.Leaderboard.LeaderboardServer)
local PlotServer = require(ServerScriptService.Features.Plot.PlotServer)
local RebirthServer = require(ServerScriptService.Features.Rebirth.RebirthServer)
local RewardsServer = require(ServerScriptService.Features.Rewards.RewardsServer)
local SwingingServer = require(ServerScriptService.Features.Swinging.SwingingServer)
local TrailsServer = require(ServerScriptService.Features.Trails.TrailsServer)
local UpgradesServer = require(ServerScriptService.Features.Upgrades.UpgradesServer)
local WheelServer = require(ServerScriptService.Features.Wheel.WheelServer)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local BoostServiceServer = require(ServerScriptService.Modular.Services.BoostService.BoostServiceServer)
local FunnelServiceServer = require(ServerScriptService.Modular.Services.FunnelService.FunnelServiceServer)
local ItemServiceServer = require(ServerScriptService.Modular.Services.ItemService.ItemServiceServer)
local LuckServiceServer = require(ServerScriptService.Modular.Services.LuckService.LuckServiceServer)
local MonitizationServiceServer = require(ServerScriptService.Modular.Services.MonitizationService.MonitizationServiceServer)

local dataservice = require(ReplicatedStorage.Packages.dataservice).server

function dataservice:onPlayerInit(player:Player, data)
    -- MODULAR --
    FunnelServiceServer:playerAdded(player, data)
    MonitizationServiceServer:playerAdded(player, data)
    BoostServiceServer:playerAdded(player, data)
    

    -- FEATURES --
    AppServer:playerAdded(player, data)
    PlotServer:playerAdded(player)
    FriendsServer:playerAdded(player)
    SwingingServer:playerAdded(player)
    TrailsServer:playerAdded(player, data)
    LeaderboardServer:playerAdded(player, data)
end

dataservice:addPlayerRemovingCallback(function(player: Player, data)
    
    -- FEATURES --
    PlotServer:playerRemoved(player)
    FriendsServer:playerRemoved(player)
    TrailsServer:playerRemoved(player)
    LeaderboardServer:playerRemoved(player)

    -- MODULAR --
    BoostServiceServer:playerRemoved(player, data)
end)

dataservice:init({
    template = DataTemplate,
    profileStoreIndex = "Testing",
    useMock = true,
})

-- MODULAR --
BoostServiceServer:init()
FunnelServiceServer:init()
ItemServiceServer:init()
LuckServiceServer:init()
MonitizationServiceServer:init()

-- FEATURES --
AppServer:init()
PlotServer:init()
UpgradesServer:init()
SwingingServer:init()
RebirthServer:init()
RewardsServer:init()
WheelServer:init()
FriendsServer:init()
TrailsServer:init()
LeaderboardServer:init()