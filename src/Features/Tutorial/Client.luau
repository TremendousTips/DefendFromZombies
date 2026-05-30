local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local stepsFolder = ReplicatedStorage.Shared.Features.Tutorial.Steps
local tutorialClient = {}

function tutorialClient.init(self:tutorialClient)
    self.networker = networker.client.new("tutorialFeature", self)

    if dataservice:get("TutorialCompleted") then return end
    

    for i, _ in stepsFolder:GetChildren() do
        local v = stepsFolder:FindFirstChild(tostring(i)) 
        local step = require(v) :: (()->(signal.Signal<>))
        step():Wait()
    end
end

type tutorialClient = typeof(tutorialClient)

return tutorialClient :: tutorialClient