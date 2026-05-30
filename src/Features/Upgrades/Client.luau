local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradesSlice = require(script.Parent.UpgradesSlice)
local networker = require(ReplicatedStorage.Packages.networker)
local upgradesClient = {}

function upgradesClient.init(self:upgradesClient)
    self.networker = networker.client.new("upgradesFeature", self)

    UpgradesSlice.requestUpgrade:Connect(function(upgrade: string)
        local _success = self.networker:fetch("requestUpgrade", upgrade)
    end)
end

type upgradesClient = typeof(upgradesClient)

return upgradesClient :: upgradesClient