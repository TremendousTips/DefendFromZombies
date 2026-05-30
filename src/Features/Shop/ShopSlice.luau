local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local source = vide.source

local serverLuck = source(1) :: vide.Source<number>
local serverLuckProductId = source(3515103497) :: vide.Source<number>


return {
    serverLuck = serverLuck,
    serverLuckProductId = serverLuckProductId,
}