local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotSync = require(script.Parent.PlotSync)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local crateClass = {}
crateClass.__index = crateClass

export type crate = {
    owner: Player,

    timeLeft: number,
    readyToOpen: boolean,
    connection: RBXScriptConnection,
}

type props = {
    Stand: number,
    CrateInfo: DataTemplate.CrateInfo,
}

function crateClass.new(props:props)
    local self = setmetatable({}, crateClass)
    
    self.timeLeft = props.CrateInfo.Time
    self.readyToOpen = false

    local connection = nil :: RBXScriptConnection?
    connection = PlotSync.onTick:Connect(function()  
        self.timeLeft = math.max(self.timeLeft - 1, 0)
        if self.timeLeft == 0 then
            self.readyToOpen = true
            connection:Disconnect()        
        end
    end)
    
    self.connection = connection

    return self :: crate
end

return crateClass