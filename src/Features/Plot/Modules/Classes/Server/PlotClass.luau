local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plot = {}
plot.__index = plot

local parent = Instance.new("Folder")
parent.Name = "Plots"
parent.Parent = game.Workspace

export type plot = {
    index: number,
    owner: Player?,

    model: Model,
    spawnConnection: RBXScriptConnection?,

    getModel: ((self:plot)->(Model)),
    isClaimed: ((self:plot)->(boolean)),
    claim: ((self:plot, player:Player)->()),
    unclaim: ((self:plot)->()),
}

function plot.spawn(index:number, part:Part)
    local self = setmetatable({}, plot) :: plot

    self.index = index

    self.owner = nil

    self.model = ReplicatedStorage.Assets.Plot:Clone()
    self.model:PivotTo(part.CFrame)
    self.model.Name = index
    self.model.Parent = parent

    return self
end

function plot.getModel(self:plot)
    return self.model
end

function plot.isClaimed(self:plot)
    return if self.owner then true else false
end

function plot.claim(self:plot, player:Player)
    self.owner = player
    task.spawn(function()
        local character = player.Character or player.CharacterAdded:Wait()
        character:PivotTo(self.model.Spawn.CFrame + Vector3.new(0, 2, 0))
    end)
    self.spawnConnection = player.CharacterAdded:Connect(function(character: Model)  
        character:PivotTo(self.model.Spawn.CFrame + Vector3.new(0, 2, 0))
    end)
end

function plot.unclaim(self:plot)
    self.owner = nil
    self.spawnConnection:Disconnect()
end


return plot