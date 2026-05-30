local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local tutorialServer = {}

function tutorialServer.init(self:tutorialServer)
    self.networker = networker.server.new("tutorialFeature", self)
end

type tutorialServer = typeof(tutorialServer)

return tutorialServer :: tutorialServer