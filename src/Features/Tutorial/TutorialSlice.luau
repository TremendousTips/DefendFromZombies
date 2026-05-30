local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local overlayVisible = source(false) :: vide.Source<boolean>
local overlayPosition = source(UDim2.fromScale(0.5, 0.5)) :: vide.Source<UDim2>
local overlaySize = source(UDim2.fromScale(1,1)) :: vide.source<UDim2>


return {
    overlayVisible = overlayVisible,
    overlayPosition = overlayPosition,
    overlaySize = overlaySize,
}