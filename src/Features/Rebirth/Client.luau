local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local RebirthSlice = require(script.Parent.RebirthSlice)
local networker = require(ReplicatedStorage.Packages.networker)
local RebirthRequirements = require(ReplicatedStorage.Shared.Features.Rebirth.Modules.RebirthRequirements)
local rebirthClient = {}

function rebirthClient.init(self:rebirthClient)
    self.networker = networker.client.new("rebirthFeature", self)

    RebirthSlice.attemptRebirth:Connect(function()
        self.networker:fetch("attemptRebirth")
    end)

    dataservice:getChangedSignal({"Rebirth"}):Connect(function(val:number)
        RebirthSlice.requirements(RebirthRequirements[val+1])       
    end)
end

type rebirthClient = typeof(rebirthClient)

return rebirthClient :: rebirthClient