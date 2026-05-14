local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
local sift = require(ReplicatedStorage.Packages.sift)
local TowerClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Towers.TowerClassClient)
local plotClass = {}
plotClass.__index = plotClass

local PlotSlice = {}

local parent = Instance.new("Folder")
parent.Parent = game.Workspace
parent.Name = "Plots"

export type plotClass = {
    
    owner: Player?,
    model: Model,

    stands: {
        [number]: TowerClassClient.towerClass
    },

    getModel: ((self:plotClass)->(Model)),
    getOwner: ((self:plotClass)->(Player?)),
}

type props = {
    Index: number,
    CFrame: CFrame
}

local atom = charm.atom
local subscribe = charm.subscribe

function plotClass.new(props:props)
    local self = setmetatable({}, plotClass)

    self.owner = nil

    local model = ReplicatedStorage.Assets.Plot:Clone()
    model.Parent = parent
    model:PivotTo(props.CFrame)
    model.Name = props.Index

    PlotSlice.PlotStands[props.Index] = atom({})

    subscribe(PlotSlice.PlotStands[props.Index], function(state, prev)  
        for index, info in state do
            if prev[index] then
                if not sift.Dictionary.equals(info, prev[index]) then
                    -- edit the stand
                end
            else
                if info.Type == "Tower" then
                    self.stands[index] = TowerClassClient.new {
                        Index = index,
                        TowerInfo = info
                    }
                elseif info.Type == "Crate" then
                    self.stands[index] = CrateClassClient.new {
                        Index = index,
                        CrateInfo = info
                    }
                end
            end
        end
    end)


    self.model = model

    return self :: plotClass
end

function plotClass.getModel(self:plotClass)
    return self.model
end

function plotClass.getOwner(self:plotClass)
    return self.owner
end

return plotClass