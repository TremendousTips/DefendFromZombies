local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local requirements = source {} :: vide.Source<{}>

local attemptRebirth = signal.new() :: signal.Signal<>

return {
    attemptRebirth = attemptRebirth,

    requirements = requirements,
}