local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local openMenu = signal.new() :: signal.Signal<string>
local requestGroupReward = signal.new() :: signal.Signal<>

local cashAmount = source(0) :: vide.Source<number>
local winsAmount = source(0) :: vide.Source<number>

local cashPotionTime = source(0) :: vide.Source<number>
local speedPotionTime = source(0) :: vide.Source<number>
local winsPotionTime = source(0) :: vide.Source<number>

local groupRewardCooldown = source(0) :: vide.Source<number>

return {
    openMenu = openMenu,
    requestGroupReward = requestGroupReward,

    cashAmount = cashAmount,
    winsAmount = winsAmount,

    cashPotionTime = cashPotionTime,
    speedPotionTime = speedPotionTime,
    winsPotionTime = winsPotionTime,

    groupRewardCooldown = groupRewardCooldown,
}