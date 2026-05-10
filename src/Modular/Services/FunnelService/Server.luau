local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local networker = require(ReplicatedStorage.Packages.networker)
local server = {}

type data = {
    FunnelData: {
        [string]: {
            completed: boolean,
            step: number,
        }
    }?
}

function server.init(self:server)
    self.networker = networker.server.new("funnelService", self, {self.completedStep, self.completedFunnel})

    self.registeredSteps = {} :: {
        [string]: {
            [number]: string 
        }
    }
end

function server.playerAdded(_self:server, _player:Player, data:data)
    if not data.FunnelData then
        data.FunnelData = {}
    end
end

function server.validateStep(self:server, funnel:string, step:number, name:string)
    if not self.registeredSteps[funnel] then
        self.registeredSteps[funnel] = {}
    end
    self.registeredSteps[funnel][step] = name
end

function server.completedStep(self:server, player:Player, funnel:string, step:number, name:string, completed:boolean?)
    if self.registeredSteps[funnel][step] ~= name then
        return
    end

    local data = dataservice:get(player) :: data
    local funnelData = data.FunnelData

    

    if not funnelData[funnel] then
        dataservice:set(player, {"FunnelData", funnel}, {
            completed = completed or false,
            step = step,
        })
    else
        if funnelData[funnel].step >= step then
            return
        end
    end

    AnalyticsService:LogFunnelStepEvent(player, funnel, nil, step, name)    
end

type server = typeof(server)

return server :: server