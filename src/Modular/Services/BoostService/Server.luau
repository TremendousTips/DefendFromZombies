local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local BoostServiceUtils = require(ReplicatedStorage.Shared.Modular.Services.BoostService.BoostServiceUtils)
local server = {}

function server.init(self:server)
    self.networker = networker.server.new("BoostService", self, {self.getBoost, self.getTimedBoost})

    self.playerBoosts = {} :: {
        [number]: {
            [string]:number
        }
    }

    self.playerBoostSources = {} :: {
        [number]: {
            [string]: {
                [string]: number
            }
        }
    }

    self.playerTimedBoosts = {} :: {
        [number]: {
            [string]: {
                [string]: {time:number, sessionStart:number}
            }
        }
    }
    task.spawn(function()
        while task.wait(1) do
            for userId, boosts in self.playerTimedBoosts do
                for boost, sources in boosts do
                    for source, thyme in sources do
                        if (thyme.time + thyme.sessionStart) <= os.time() then
                            self:removeBoost(Players:GetPlayerByUserId(userId), boost, source)
                        end
                    end
                end
            end
        end
    end)
end

function server.recalculateBoost(self:server, player:Player, boost:string)
    self.playerBoosts[player.UserId][boost] = BoostServiceUtils:getBoostSum(self.playerBoostSources[player.UserId][boost])
end


--[[
    Adds boost source to player's data. 
    @param boost = boost's name Eg: "Strength", "Luck"
    @param amount = boost percentage Eg: 25, 100,
    @param source = what gave the boost Eg: "Potion", "GamepassName"
    @param timed = when does the boost run out Eg: 300 -- 300 seconds
]]
function server.addBoost(self:server, player:Player, boost:string, source:string, amount:number, timed:number?)
    self:boostExist(player, boost)
    self.playerBoostSources[player.UserId][boost][source] = amount
    self:recalculateBoost(player, boost) 
    if timed then
        if self.playerTimedBoosts[player.UserId][boost][source] then
            self.playerTimedBoosts[player.UserId][boost][source].time += timed
        else
            self.playerTimedBoosts[player.UserId][boost][source] = {
                time = timed,
                sessionStart = os.time(),
            }
        end
    end
end

--[[
    Removes boost source from player's data.
    @param boost = boost's name Eg: "Strength", "Luck"
    @param source = what gave the boost Eg: "Potion", "GamepassName"
]]
function server.removeBoost(self:server, player:Player, boost:string, source:number)
    self.playerBoostSources[player.UserId][boost][source] = nil
    self.playerTimedBoosts[player.UserId][boost][source] = nil
    
    self:recalculateBoost(player, boost) 
end

--[[
    Returns the player boost percentage.
    @param boost = boost's name Eg: "Strength", "Luck"
    @return number Eg, 200, 30, 201
]]
function server.getBoost(self:server, player:Player, boost:string)
    if not self.playerBoosts[player.UserId] then return 100 end
    if not self.playerBoosts[player.UserId][boost] then return 100 end
    
    return (self.playerBoosts[player.UserId][boost] or 0) + 100
end

--[[
    Returns the player timed boost timeInfo.
    @param boost = boost's name Eg: "Strength", "Luck"
    @return Time left :: number
]]
function server.getTimedBoost(self:server, player:Player, boost:string, source:string)
    local boostMap = self.playerTimedBoosts[player.UserId][boost]
    local timedInfo = boostMap and boostMap[source]
    if not timedInfo then
        return 0
    end
    return math.max((timedInfo.sessionStart + timedInfo.time) - os.time(), 0)
end

function server.playerAdded(self:server, player:Player, data:DataTemplate.data)
    self.playerBoostSources[player.UserId] = {}
    self.playerBoosts[player.UserId] = {}
    self.playerTimedBoosts[player.UserId] = {}

    if not data.BoostData then
        data.BoostData = {
            Timed = {}
        }
    end

    self.playerTimedBoosts[player.UserId] = data.BoostData.Timed
    self:updateBoostSession(player)
end

function server.playerRemoved(self:server, player:Player, data)
    data.BoostData.Timed = self.playerTimedBoosts[player.UserId]

    self.playerBoostSources[player.UserId] = nil
    self.playerBoosts[player.UserId] = nil
    self.playerTimedBoosts[player.UserId] = nil
end

function server.updateBoostSession(self:server, player:Player)
    for _boost, sources in self.playerTimedBoosts[player.UserId] do
        for _source, thyme in sources do
            thyme.sessionStart = os.time()
        end
    end
end

function server.boostExist(self:server, player:Player, boost:string)
    if not self.playerBoostSources[player.UserId][boost] then
        self.playerBoostSources[player.UserId][boost] = {}
        self.playerBoosts[player.UserId][boost] = {}
        self.playerTimedBoosts[player.UserId][boost] = {}
    end
end


type server = typeof(server)

return server :: server