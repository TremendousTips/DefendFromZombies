local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Zombies = require(ReplicatedStorage.Shared.Features.Plot.Modules.Zombies)
local zombieClass = {}
zombieClass.__index = zombieClass

export type zombieClass = {
    level: number,
    health: number,
    player: Player,
}

type props = {
    player: Player,
    level: number,    
}

function zombieClass.new(props:props)
    local self = setmetatable({}, zombieClass)

    self.player = props.player
    self.level = props.level
    self.health = Zombies:getHealthFromLevel(props.level)

    if self.clientNew then
        self:clientNew()
    end

    if self.serverNew then
        self:serverNew()
    end

    return self
end

function zombieClass.damage(self, damage:number)
    self.health = math.max(self.health - damage, 0)
    if self.health == 0 then
        self:kill()
    end
end

function zombieClass.kill(self)
    setmetatable(self, nil)
end

return zombieClass