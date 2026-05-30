local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local signal = require(ReplicatedStorage.Packages.signal)
local sync = {} 

local TPS = 1

function sync.init(self:sync, startingTime:number?, currentTick:number?)
    self.onTick = signal.new()
    self.tick = currentTick or 0

    self.startTime = startingTime or workspace:GetServerTimeNow()
    RunService.Heartbeat:Connect(function(...)  
        self:loop(...)
    end)
end

function sync.loop(self:sync)
    local currentTick = math.round((workspace:GetServerTimeNow()-self.startTime)*TPS)
    if self.tick >= currentTick then return end
    while self.tick < currentTick do
        self.tick += 1
        self.onTick:Fire(self.tick)
    end

end

type sync = typeof(sync)

return sync :: sync