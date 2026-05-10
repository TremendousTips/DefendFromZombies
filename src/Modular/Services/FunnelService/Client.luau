local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local client = {}

type step = {
    Name: string,
    Completed: signal.Signal<>,
    Callback: ((completed:signal.Signal<>)->()),
}

type data = {
    FunnelData: {
        [string]: {
            completed: boolean,
            step: number,
        }
    }?
}

function client.init(self:client)
    self.networker = networker.client.new("funnelService",self)

    self.funnels = {} :: {
        [string]: {
            [number]:step
        }
    }
end

--[[
    Resumes a funnel from where the player left off, or starts it from the beginning.
    @param funnel = funnel's name Eg: "Onboarding"
]]
function client.resumeFunnel(self:client, funnel:string)
    local data = dataservice:get() :: data
    local funnelData = data.FunnelData
    if not funnelData[funnel] then
        self:__step(funnel)    
    elseif not funnelData[funnel].completed then
        self:__step(funnel, funnelData[funnel].step)
    end
end

--[[
    Registers a step in a funnel with a callback to execute when that step is reached.
    @param funnel   = funnel's name Eg: "Onboarding"
    @param step     = step index Eg: 1, 2, 3
    @param name     = step's display name Eg: "EquipItem"
    @param callback = function called with a Completed signal when the step runs
]]
function client.registerStep(self:client, funnel:string, step:number, name:string, callback:((completed:signal.Signal<>)->()))
    if not self.funnels[funnel] then
        self.funnels[funnel] = {}
    end

    self.funnels[funnel][step] = {
        Name = name,
        Completed = signal.new(),
        Callback = callback,
    }
end

function client.stepCompleted(self:client, funnel:string, step:number, name:string)
    self.networker:fire("completedStep", funnel, step, name, false)
end

function client.__step(self:client, funnel:string, step:number)
    if not self.funnels[funnel][step] then
        return
    else
        local completed = self.funnels[funnel][step].Completed        
        self.funnels[funnel][step].Callback(completed)
        
        completed:Once(function()  
            local name = self.funnels[funnel][step].Name

            local isLastStep = if not self.funnels[funnel][step+1] then true else false

            self.networker:fire("completedStep", funnel, step, name, isLastStep)

            if not isLastStep then
                self.__step(funnel, step+1)
            else
                return
            end
        end)
    end
end

type client = typeof(client)

return client :: client