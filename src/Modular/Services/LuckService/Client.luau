local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local LuckServiceUtils = require(ReplicatedStorage.Shared.Modular.Services.LuckService.LuckServiceUtils)
local client = {}

type tbl = {
    [string]:{
        Weight:number
    }
}

--[[
    Initializes the LuckService client and connects to the server networker.
]]
function client.init(self:client)
    self.networker = networker.client.new("LuckService", self)
end

--[[
    Gets a random item key from a weighted table, influenced by luck.
    @param tbl  - table of items with a Weight field
    @param luck - luck multiplier as a percentage (e.g. 100 = default)
]]
function client.getWeightedRandom(_self: client, tbl: tbl, luck: number): string
    return LuckServiceUtils.getWeightedRandom(tbl, luck)
end

--[[
    Returns the percentages of every item in a weighted table
    @param tbl = table of items with property Weight
]]
function client.getWeightedOdds(self:client, tbl:tbl)
    local weightedOdds = self.networker:fetch("getWeightedOdds")
    return weightedOdds
end

type client = typeof(client)

return client