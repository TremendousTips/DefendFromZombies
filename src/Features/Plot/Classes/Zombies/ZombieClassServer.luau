local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local signal = require(ReplicatedStorage.Packages.signal)
local Zombies = require(ReplicatedStorage.Shared.Features.Plot.Modules.Zombies)
local zombieClass = {}
zombieClass.__index = zombieClass

export type zombieClass = {
    level: number,

    health: number,
    player: Player,

    died: signal.Signal<>,

    remove: ((self:zombieClass)->()),

}


type props = {
    Level: number,
    Player: Player
}

function zombieClass.new(props:props)
    local self = setmetatable({}, zombieClass)

    self.level = props.Level
    self.health = Zombies:getHealthFromLevel(props.Level)
    self.player =  props.Player

    self.died = signal.new()

    return self :: zombieClass
end

function zombieClass.damage(self:zombieClass, damage:number)
    local prevHealth = self.health
    self.health = math.max(self.health-damage, 0)
    local dealtDamage = prevHealth - self.health
    dataservice:update(self.player, {"Cash"}, function(preVal:number)  
        return preVal + dealtDamage
    end)
    if self.health == 0 then
        self:kill()
    end
end

function zombieClass.kill(self:zombieClass)
    self.died:Fire()
    self:remove()
end

function zombieClass.remove(self:zombieClass)
    self.died:Destroy()
    setmetatable(self, nil)
end


return zombieClass