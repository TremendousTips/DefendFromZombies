local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StandButton = require(script.Parent.StandButton)
local UpgradeButtonClass = require(script.Parent.UpgradeButtonClass)
local charm = require(ReplicatedStorage.Packages.charm)
local dataservice = require(ReplicatedStorage.Packages.dataservice).client
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
parent.Name = "Plots"

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

    standPurchaseButton: Model,
    conveyerButton: Part,

    conveyer: ConveyerClassClient.conveyerClass,
    
    upgradeConveyer: ((self:plotClass, level:number)->()),
    removeConveyerCrate: ((self:plotClass)->()),
    skipConveyerCrate: ((self:plotClass)->()),

    place: ((self:plotClass, stand:number, info:{})->()),
    remove: ((self:plotClass, stand:number)->()),

    unlockStand: ((self:plotClass, stand:number)->()),
    lockStand: ((self:plotClass, stand:number)->()),


    promptTriggered: signal.Signal<number,string>,


    zombies: {ZombieClassClient.zombieClass},

    makeZombie: ((self:plotClass)->()),
    getRandomZombie: ((self:plotClass, seed:number)->(ZombieClassClient.zombieClass?)),

    setUpUpgradeButtons: ((self:plotClass)->()),
}

type props = {
    Index: number,
    CFrame: CFrame
}

local MAX_ZOMBIES = 5

local atom = charm.atom
local subscribe = charm.subscribe

local source = vide.source
local spring = vide.spring
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
        Level = dataservice:get({"Upgrades", "Conveyer"})
    }

    root(function()
        local crateButton = model.SpawnCrate :: Model
        local primaryPart = crateButton.PrimaryPart :: Part
        local cd = Instance.new("ClickDetector")
        cd.Parent = primaryPart
        self.conveyerButton = primaryPart

        local offsetSource = source(0)
        local offsetSpring = spring(offsetSource, 0.2, 0.6)

        local db = false
        cd.MouseClick:Connect(function()
            if db then return end
            db = true
            PlotSlice.attemptSkipCrate:Fire()
            offsetSource(1)
            task.wait(0.15)
            offsetSource(0)
            db = false
        end)

        local cframe = primaryPart.CFrame

        local standPurchaseButton = ReplicatedStorage.Assets.StandButton:Clone() :: Model

        StandButton {
            Model = standPurchaseButton,
            Activated = function()
                PlotSlice.attemptUnlockStand:Fire()
            end
        }
        standPurchaseButton.Parent = workspace
        standPurchaseButton:PivotTo(CFrame.new(0, -200, 0))

        self.standPurchaseButton = standPurchaseButton

        effect(function()
            primaryPart.CFrame = cframe + ((primaryPart.CFrame.LookVector) / 4)*offsetSpring()
        end)     
     
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
                            stand.ProxText("Skip Wait")
                        end
                    else
                        stand.ProxVisible(true)
                        stand.ProxText("Remove")
                    end
                end
            end
        end)
    end)
    Sync.onTick:Connect(function(currentTick:number)  
        while #self.zombies < MAX_ZOMBIES do
            self:makeZombie()
        end
        for index, stand in self.standClasses do
            if stand.Type == "Tower" then
                local tower = stand.Class :: TowerClassClient.towerClass
                local zombie = self:getRandomZombie(currentTick)
                if zombie then
                    tower:attack(zombie)
                end
            elseif stand.Type == "Crate" then
                local crate = stand.Class :: CrateClassClient.crateClass
                crate:tick()
                local timeLeft = crate:getTime()
                if timeLeft == 0 then
                    self.stands[index].ProxText("Open")
                end
            end
        end
    end)

    self:setUpUpgradeButtons()

    return self :: plotClass
end

function plotClass.upgradeConveyer(self:plotClass, level:number)
    self.conveyer:upgrade(level)
end

function plotClass.removeConveyerCrate(self:plotClass)
    self.conveyer:removeCrate()
end

function plotClass.skipConveyerCrate(self:plotClass, crateInfo)
    self.conveyer:spawnCrate(crateInfo)
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

    prox.Triggered:Connect(function()
        self.promptTriggered:Fire(stand, text())
    end)


    local nextPoint = self.model.StandCFrames:FindFirstChild(tostring(stand+1)) :: Part?
    if nextPoint then
        self.standPurchaseButton:PivotTo(nextPoint.CFrame)
    end

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

function plotClass.setUpUpgradeButtons(self:plotClass)
    local conveyerUpgradePoint = self.model.ConveyerUpgradePoint :: Part
    UpgradeButtonClass.create {
        Upgrade = "Conveyer",
        CFrame = conveyerUpgradePoint.CFrame
    }
end


return plotClass