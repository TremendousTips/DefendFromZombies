local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local client = {}

--[[
    Initializes the BoostService client and connects to the server networker.
]]
function client.init(self:client)
    self.networker = networker.client.new("BoostService", self)
end

--[[
    Returns the player boost percentage.
    @param boost = boost's name Eg: "Strength", "Luck"
    @return number Eg, 200, 30, 201
]]
function client.getBoost(self:client, boost:string)
    local amount = self.networker:fetch("getBoost", boost)
    return amount :: number
end

--[[
    Returns the player timed boost timeInfo.
    @param boost = boost's name Eg: "Strength", "Luck"
    @return Time left :: number
]]
function client.getTimedBoost(self:client, boost:string, source:string)
    local timeLeft = self.networker:fetch("getTimedBoost", boost, source)
    return timeLeft :: number
end

type client = typeof(client)

return client :: client