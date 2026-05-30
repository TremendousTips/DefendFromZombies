local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local isHolding = vide.source(false) :: vide.Source<boolean>

return {
    isHolding = isHolding 
}