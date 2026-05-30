local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local openMenu = signal.new() :: signal.Signal<string>
local requestGroupReward = signal.new() :: signal.Signal<>

local cashAmount = source(0) :: vide.Source<number>

local hideHUD = source(false) :: vide.Source<boolean>

return {
    openMenu = openMenu,
    requestGroupReward = requestGroupReward,

    cashAmount = cashAmount,
    hideHUD = hideHUD,
}