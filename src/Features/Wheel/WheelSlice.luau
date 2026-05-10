local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)
local source = vide.source

local requestSpin = signal.new() :: signal.Signal<>

local wheelRotation = source(0) :: vide.Source<number>
local rolledIndex = source(1) :: vide.Source<number>
local spins = source(0) :: vide.Source<number>
local wheelVisible = source(false) :: vide.Source<boolean>

return {
    requestSpin = requestSpin,

    spins = spins,
    wheelRotation = wheelRotation,
    rolledIndex = rolledIndex,
    wheelVisible = wheelVisible,
}