local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)
local source = vide.source


local attemptPurchaseCrate = signal.new() :: signal.Signal<>
local attemptSkipCrate = signal.new() :: signal.Signal<>
local attemptUnlockStand = signal.new() :: signal.Signal<>

local plotStands = source({}) :: vide.Source<{}>



return {
    attemptPurchaseCrate = attemptPurchaseCrate,
    attemptSkipCrate = attemptSkipCrate,
    attemptUnlockStand = attemptUnlockStand, 
    
    plotStands = plotStands
}