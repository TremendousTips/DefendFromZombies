local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local zombieClass = {}
zombieClass.__index = zombieClass

export type zombie = {
    owner: Player,

    health: number,

    damagedSignal: signal.Signal<number>,
    diedSignal: signal.Signal<>,

    damage: ((self:zombie, damage:number)->()),
    died: ((self:zombie)->()),
}

type props = {
    owner: Player,
    zombieLevel: number,
}

function zombieClass.new(props:props)
    local self = setmetatable({}, zombieClass)

    self.owner = props.owner

    self.health = 0    

    self.damagedSignal = signal.new()
    self.diedSignal = signal.new()

    return self :: zombie
end

function zombieClass.damage(self:zombie, damage:number)
    self.health = math.max(self.health - damage, 0)
    self.damagedSignal:Fire(damage)
    if self.health == 0 then
        self:died()
    end
end

function zombieClass.died(self:zombie)
    self.diedSignal:Fire()
    setmetatable(self, nil)
end

return zombieClass