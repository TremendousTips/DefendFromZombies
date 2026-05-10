local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local sync = {}

local TPS = 1

function sync.init(self:sync)
    self.tick = 0
    self.onTick = signal.new()
    self.startTime = workspace:GetServerTimeNow()
    sync:loop(workspace:GetServerTimeNow())
end

function sync.loop(self:sync, time:number)
    local currentTick = math.round((workspace:GetServerTimeNow() - self.startTime)*TPS)
    while currentTick < self.tick do
        self.tick += 1
        self.onTick:Fire(self.tick)
    end
end

type sync = typeof(sync)

return sync :: sync