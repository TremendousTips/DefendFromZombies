local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)
local InventorySlice = require(ReplicatedStorage.Shared.Features.Inventory.InventorySlice)
local ConveyerClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Conveyer.ConveyerClassClient)
local CrateClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Crates.CrateClassClient)
local TowerClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Towers.TowerClassClient)
local ZombieClassClient = require(ReplicatedStorage.Shared.Features.Plot.Classes.Zombies.ZombieClassClient)
local Sync = require(ReplicatedStorage.Shared.Features.Plot.Modules.Sync)
local PlotSlice = require(ReplicatedStorage.Shared.Features.Plot.PlotSlice)
local plotClass = {}
plotClass.__index = plotClass

local parent = Instance.new("Folder")
parent.Parent = game.Workspace
parent.Name = "NotPlayerPlots"

export type plotClass = {
    
    owner: Player?,
    model: Model,

    standClasses: {
        [number]: {
            Type: "Tower" | "Crate" | "Empty",
            Class: TowerClassClient.towerClass? | CrateClassClient.crateClass?,
        }
    },
    stands: {
        [number]: {
            StandModel: Model,
            ProxText: charm.Atom<string>,
            ProxVisible: charm.Atom<boolean>,
        }
    },

    conveyer: ConveyerClassClient.conveyerClass,
    
    upgradeConveyer: ((self:plotClass, level:number)->()),
    removeConveyerCrate: ((self:plotClass)->()),
    skipConveyerCrate: ((self:plotClass)->()),

    place: ((self:plotClass, stand:number, info:{})->()),
    remove: ((self:plotClass, stand:number)->()),

    unlockStand: ((self:plotClass, stand:number)->()),
    lockStand: ((self:plotClass, stand:number)->()),


    tickConnection: RBXScriptConnection?,

    destroy: ((self:plotClass)->()),

    promptTriggered: signal.Signal<number,string>,


    zombies: {ZombieClassClient.zombieClass},

    makeZombie: ((self:plotClass)->()),
    getRandomZombie: ((self:plotClass, seed:number)->(ZombieClassClient.zombieClass?)),
    unclaim: ((self:plotClass)->()),
    claim: ((self:plotClass)->()),
}

type props = {
    Index: number,
    CFrame: CFrame,
    ConveyerLevel: number
}

local MAX_ZOMBIES = 5

local atom = charm.atom
local subscribe = charm.subscribe

local effect = vide.effect
local root = vide.root

function plotClass.new(props:props)
    local self = setmetatable({}, plotClass) :: plotClass

    self.owner = nil

    local model = ReplicatedStorage.Assets.Plot:Clone()
    model.Parent = parent
    model:PivotTo(props.CFrame)
    model.Name = props.Index

    self.model = model

    self.standClasses = {}
    self.stands = {}
    self.zombies = {}

    self.standModels = {}

    self.promptTriggered = signal.new()

    self.conveyer = ConveyerClassClient.new {
        CFrame = model.ConveyerPoint.CFrame,
        Level = props.ConveyerLevel
    }

    

    root(function()
        effect(function()
            local _stands = PlotSlice.plotStands()
            if InventorySlice.isHolding() then
                for _, stand in self.stands do
                    stand.ProxVisible(true)
                    stand.ProxText("Place")
                end
            else
                for indx, stand in self.stands do
                    local classStand = self.standClasses[indx]
                    if classStand.Type == "Empty" then
                        stand.ProxVisible(false)
                        stand.ProxText("Place")
                    elseif classStand.Type == "Crate" then
                        stand.ProxVisible(true)
                        local timeLeft = self.standClasses[indx].Class:getTime()
                        if timeLeft == 0 then
                            stand.ProxText("Open")
                        else
                            stand.ProxText("Remove")
                        end
                    else
                        stand.ProxVisible(true)
                        stand.ProxText("Remove")
                    end
                end
            end
        end)
    end)
    

    return self :: plotClass
end

function plotClass.claim(self:plotClass)
    self.tickConnection = Sync.onTick:Connect(function(currentTick:number)  
        while #self.zombies < MAX_ZOMBIES do
            self:makeZombie()
        end
        for _, stand in self.standClasses do
            if stand.Type == "Tower" then
                local tower = stand.Class :: TowerClassClient.towerClass
                local zombie = self:getRandomZombie(currentTick)
                if zombie then
                    tower:attack(zombie)
                end
            elseif stand.Type == "Crate" then
                local crate = stand.Class :: CrateClassClient.crateClass
                crate:tick()
            end
        end
    end)
end

function plotClass.unclaim(self:plotClass)
    self.tickConnection:Disconnect()
    for _, zombie in self.zombies do
        zombie:remove()
    end
    self.zombies = {}
    for _, standClasses in self.standClasses do
        standClasses.Class:remove()
    end
    self.standClasses = {}
    self.owner = nil
end

function plotClass.place(self:plotClass, stand:number, info)
    if info.Type == "Tower" then
        self.standClasses[stand] = {
            Type = info.Type,
            Class = TowerClassClient.new {
                Plot = self.model,
                Stand = stand,
                TowerInfo = info   
            }
        }
    elseif info.Type == "Crate" then
        self.standClasses[stand] = {
            Type = info.Type,
            Class = CrateClassClient.new {
                Plot = self.model,
                Stand = stand,
                CrateInfo = info   
            }
        }
    elseif info.Type == "Empty" then
        self.standClasses[stand] = {
            Type = info.Type
        }
    end
    local edited = PlotSlice.plotStands()
    edited[stand] = info
    PlotSlice.plotStands(edited)
end

function plotClass.remove(self:plotClass, stand:number)
    self.standClasses[stand].Class:remove()
    self.standClasses[stand].Type = "Empty"
    self.stands[stand].ProxText("Place")
    self.stands[stand].ProxVisible(false)
    local edited = PlotSlice.plotStands()
    edited[stand] = {
        Type = "Empty"
    }
    PlotSlice.plotStands(edited)
end

function plotClass.upgradeConveyer(self:plotClass, level:number)
    self.conveyer:upgrade(level)
end

function plotClass.unlockStand(self:plotClass, stand:number)
    local model = ReplicatedStorage.Assets.Stand:Clone() :: Model
    model.Parent = workspace
    model:PivotTo(self.model.StandCFrames:WaitForChild(tostring(stand)).CFrame)
    local text = atom("Place")
    local visible = atom(false)
    
    local prox = model.PrimaryPart.Attachment.ProximityPrompt :: ProximityPrompt
    subscribe(text, function(state, _)
        prox.ActionText = state
    end)
    subscribe(visible, function(state)
        prox.Enabled = state
    end)

    self.stands[stand] = {
        StandModel = model,
        ProxText = text,
        ProxVisible = visible,
    }
end

function plotClass.makeZombie(self:plotClass)
    local zombie = ZombieClassClient.new {
        Level = 1,
        Plot = self.model
    }
    zombie.died:Once(function()  
        local index = table.find(self.zombies, zombie)
        table.remove(self.zombies, index)
    end)
    table.insert(self.zombies, zombie)
end

function plotClass.getRandomZombie(self:plotClass, seed:number)
    if #self.zombies == 0 then return end
    local random = Random.new(seed)
    return self.zombies[random:NextInteger(1, #self.zombies)] :: ZombieClassClient.zombieClass
end

function plotClass.destroy(self:plotClass)
    if self.tickConnection then
        self.tickConnection:Disconnect()
    end
    for _, zombie in self.zombies do
        zombie:remove()
    end
    self.zombies = {}
    for _, standClasses in self.standClasses do
        standClasses.Class:remove()
    end
    self.standClasses = {}
    self.conveyer:destroy()
    self.model:Destroy()
    setmetatable(self, nil)
end

return plotClass