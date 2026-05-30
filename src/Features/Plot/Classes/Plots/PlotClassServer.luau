local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local Sync = require(ReplicatedStorage.Shared.Features.Plot.Modules.Sync)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local CrateClassServer = require(ServerScriptService.Features.Plot.Classes.Crates.CrateClassServer)
local TowerClassServer = require(ServerScriptService.Features.Plot.Classes.Towers.TowerClassServer)
local ZombieClassServer = require(ServerScriptService.Features.Plot.Classes.Zombies.ZombieClassServer)
local plotClass = {}
plotClass.__index = plotClass

type props = {
    Index: number
}

export type plotClass = {
    owner: Player?,
    model: Model,

    
    standClasses: {
        [number]: {
            Type: "Tower" | "Crate" | "Empty",
            Class: TowerClassServer.towerClass? | CrateClassServer.crateClass?,
        }
    },

    zombies: {ZombieClassServer.zombieClass},

    makeZombie: ((self:plotClass)->()),
    getRandomZombie: ((self:plotClass, seed:number)->(ZombieClassServer.zombieClass?)),

    tickConnection: RBXScriptConnection?,

    getOwner: ((self:plotClass)->(Player?)),
    getIndex: ((self:plotClass)->(number)),
    
}

local MAX_ZOMBIES = 5

function plotClass.new(props:props)
    local self = setmetatable({}, plotClass)
    
    self.standClasses = {}
    self.zombies = {}

    self.index = props.Index

    self.owner = nil

    return self :: plotClass
end

function plotClass.getOwner(self:plotClass)
    return self.owner
end

function plotClass.getIndex(self:plotClass)
    return self.index
end

function plotClass.claim(self:plotClass, player:Player)
    self.owner = player

    local playerData = dataservice:get(player) :: DataTemplate.data
    for stand, standInfo in playerData.Stands do
        self:place(stand, standInfo)
    end

    self.tickConnection = Sync.onTick:Connect(function(currentTick: number)
        self:tick(currentTick)
    end)
end

function plotClass.unclaim(self:plotClass)
    self.tickConnection:Disconnect()
    for _, zombie in self.zombies do
        zombie:remove()
    end
    self.zombies = {}
    for _, standClasses in self.standClasses do
        if standClasses ~= "Empty" then
            standClasses.Class:remove()
        end
    end
    self.standClasses = {}
    self.owner = nil
end

function plotClass.place(self:plotClass, stand:number, info)
    if info.Type == "Tower" then
        self.standClasses[stand] = {
            Type = info.Type,
            Class = TowerClassServer.new {
                Plot = self.model,
                Stand = stand,
                TowerInfo = info   
            }
        }
    elseif info.Type == "Crate" then
        self.standClasses[stand] = {
            Type = info.Type,
            Class = CrateClassServer.new {
                Plot = self.model,
                Stand = stand,
                CrateInfo = info   
            }
        }
    elseif info.Type == "Empty" then
        self.standClasses[stand] = {
            Type = info.Type
        }
    end
end

function plotClass.tick(self:plotClass, currentTick:number)
    while #self.zombies < MAX_ZOMBIES do
        self:makeZombie()
    end
    for index, stand in self.standClasses do
        if stand.Type == "Tower" then
            local tower = stand.Class :: TowerClassServer.towerClass
            local zombie = self:getRandomZombie(currentTick)
            if zombie then
                tower:attack(zombie)
            end
        elseif stand.Type == "Crate" then
            local crate = stand.Class :: CrateClassServer.crateClass
            crate:tick()
            local standInfo = dataservice:get(self.owner, {"Stands", index})
            standInfo.Time = crate:getTime()
            dataservice:set(self.owner, {"Stands", index}, standInfo)
        end
    end
end

function plotClass.remove(self:plotClass, stand:number)
    self.standClasses[stand].Class:remove()
    self.standClasses[stand].Type = "Empty"
end

function plotClass.makeZombie(self:plotClass)
    local zombie = ZombieClassServer.new {
        Level = 1,
        Player = self.owner
    }
    zombie.died:Once(function()  
        local index = table.find(self.zombies, zombie)
        table.remove(self.zombies, index)
    end)
    table.insert(self.zombies, zombie)
end

function plotClass.getRandomZombie(self:plotClass, seed:number)
    if #self.zombies == 0 then return end
    local random = Random.new(seed)
    return self.zombies[random:NextInteger(1, #self.zombies)] :: ZombieClassServer.zombieClass
end

return plotClass 