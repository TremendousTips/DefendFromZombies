local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkipWaitTimes = require(ReplicatedStorage.Shared.Features.Plot.Modules.SkipWaitTimes)
local plotUtils = {}

local MIN = 60
local HOUR = 60*MIN
local DAY = 24*HOUR

local tiers = {
    10 * MIN,
    30 * MIN,
    HOUR,
    12 * HOUR,
    DAY,
}


function plotUtils.getSkipWaitProductId(_self:plotUtils, thyme:number)
    local productId = SkipWaitTimes[DAY].ProductId

    for _, skipTime in ipairs(tiers) do
        if thyme <= skipTime then
            productId = SkipWaitTimes[skipTime].ProductId
            break
        end
    end

    return productId
end

type plotUtils = typeof(plotUtils)

return plotUtils :: plotUtils