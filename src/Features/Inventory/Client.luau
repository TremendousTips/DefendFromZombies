local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InventorySlice = require(script.Parent.InventorySlice)
local networker = require(ReplicatedStorage.Packages.networker)
require(ReplicatedStorage.Packages.satchel)
local signal = require(ReplicatedStorage.Packages.signal)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local inventoryClient = {}

function inventoryClient.init(self:inventoryClient)
    self.networker = networker.client.new("inventoryFeature", self)

    self.toolInfo = nil :: DataTemplate.StandInfo?

    self.equippedSignal = signal.new()
    self.unequippedSignal = signal.new()
    self.activatedSignal = signal.new()
end


function inventoryClient.equipped(self:inventoryClient, toolInfo:DataTemplate.StandInfo)
    self.toolInfo = toolInfo
    InventorySlice.isHolding(true)
    self.equippedSignal:Fire()
end

function inventoryClient.unequipped(self:inventoryClient)
    self.toolInfo = nil
    InventorySlice.isHolding(false)
    self.unequippedSignal:Fire()
end

function inventoryClient.activated(self:inventoryClient, toolInfo:DataTemplate.StandInfo)
    self.toolInfo = toolInfo
    self.activatedSignal:Fire(toolInfo)
end

type inventoryClient = typeof(inventoryClient)

return inventoryClient :: inventoryClient