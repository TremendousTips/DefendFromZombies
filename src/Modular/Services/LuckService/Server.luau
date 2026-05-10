
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local server = {}

function server.init(self:server)
    self.networker = networker.server.new("LuckService", self, {self.getWeightedOdds})
end

type tbl = {
    [string]:{
        Weight:number
    }
}

--[[
    Gets a random item from a weighted table
    @param tbl = table of items with property Weight
    @param luck = luck influencing number in percentage Eg: 100, 400

    ```lua
    local item = LuckServiceServer:getWeightedRandom(tbl, 200)
    ```
]]
function server.getWeightedRandom(_self:server, tbl:tbl, luck:number)
    local totalWeight = 0

    for _, info in tbl do
        totalWeight += info.Weight
    end

    local sortedTbl = {}
    for index, info in tbl do
        info.odds = info.Weight / totalWeight
        info.id = index
        table.insert(sortedTbl, info)
    end

    table.sort(sortedTbl, function(a, b)
        return a.Weight > b.Weight
    end)

    local roll = math.random()
    local sum = 0
    
    for i = #sortedTbl, 1, -1 do
        local crate = sortedTbl[i]
        local chance = 1 - (1 - tbl[crate.id].odds) ^ (luck/100)
        sum += chance
        if roll <= sum then
            return crate.id
        end
    end

    return sortedTbl[1].id
end


--[[
    Returns the percentages of every item in a weighted table
    @param tbl = table of items with property Weight
]]
function server.getWeightedOdds(_self:server, tbl:tbl)
    local totalWeight = 0

    for _, info in tbl do
        totalWeight += info.Weight
    end
    local odds = {}
    for index, info in tbl do
        odds[index] = info.Weight / totalWeight
    end

    return odds :: {
        [string]: number
    }
end

type server = typeof(server)

return server :: server

