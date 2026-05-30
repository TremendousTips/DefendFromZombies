local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local networker = require(ReplicatedStorage.Packages.networker)
local sift = require(ReplicatedStorage.Packages.sift)
local trove = require(ReplicatedStorage.Packages.trove)
local Crates = require(ReplicatedStorage.Shared.Features.Plot.Modules.Crates)
local Towers = require(ReplicatedStorage.Shared.Features.Plot.Modules.Towers)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local inventoryServer = {}

function inventoryServer.init(self:inventoryServer)
    self.networker = networker.server.new("inventoryFeature", self)

    self.toolTroves = {} :: {[number]:{[Tool]:trove.Trove}}
    self.playerTroves = {} :: {[number]:trove.Trove}
end

function inventoryServer.playerAdded(self:inventoryServer, player:Player, data)
    self.toolTroves[player.UserId] = {}
    self.playerTroves[player.UserId] = trove.new()

    task.spawn(function()
        for i, v in pairs(data.Inventory) do
            self:createTool(player, i, v, {["Index"]=i})
        end
    end)

    local indexChangedConnection = dataservice:getIndexChangedSignal(player, {"Inventory"}):Connect(function(i:number, v:DataTemplate.StandInfo)
        if v then
            self:createTool(player, i, v, {["Index"]=i})
        else
            if player.Character then
                local tool = player.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    if tool:GetAttribute("Index") == i then
                        self.networker:fire(player, "unequipped")
                    end
                end
            end
            self.toolTroves[player.UserId][i]:Clean()
            self.toolTroves[player.UserId][i]:Destroy()
        end
    end)
    self.playerTroves[player.UserId]:Add(indexChangedConnection)
end

function inventoryServer.playerRemoved(self:inventoryServer, player:Player)
    for _, v in self.toolTroves[player.UserId] do
        v:Clean()
        v:Destroy()
    end
    self.toolTroves[player.UserId] = nil
    self.playerTroves[player.UserId]:Clean()
    self.playerTroves[player.UserId] = nil
end

function inventoryServer.deleteTools(self:inventoryServer, player:Player)
    for _, v in self.toolTroves[player.UserId] do
        v:Clean()
        v:Destroy()
    end
end

function inventoryServer.createTool(self:inventoryServer, player:Player, index:number, toolInfo:DataTemplate.StandInfo, attributes:{[string]:any}?)
    local _character = player.Character or player.CharacterAdded:Wait()
    local model = ReplicatedStorage.Assets[`{toolInfo.Type}s`][toolInfo.Name]:Clone() :: Model
    model.PrimaryPart.Name = "Handle"

    local tool = Instance.new("Tool")
    tool.Name = toolInfo.Name

    self.toolTroves[player.UserId][index] = trove.new()

    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Massless = true
            v.CanCollide = false
            v.Anchored = false
        end
    end

    for _, v in pairs(model:GetChildren()) do
        v.Parent = tool
    end

    local equippedConnection = tool.Equipped:Connect(function()
        self.networker:fire(player, "equipped", toolInfo)
    end)

    local unequippedConnection = tool.Unequipped:Connect(function()  
        self.networker:fire(player, "unequipped", toolInfo)
    end)

    local activatedConnection = tool.Activated:Connect(function()  
        self.networker:fire(player, "activated", toolInfo)
    end)
    
    self.toolTroves[player.UserId][index]:Add(tool)
    self.toolTroves[player.UserId][index]:Add(equippedConnection)
    self.toolTroves[player.UserId][index]:Add(unequippedConnection)
    self.toolTroves[player.UserId][index]:Add(activatedConnection)

    if toolInfo.Type == "Crate" then
        tool.TextureId = Crates[toolInfo.Name].Image
    elseif toolInfo.Type == "Tower" then
        tool.TextureId = Towers[toolInfo.Name].Image
    end

    if attributes then
        for i, v in pairs(attributes) do
            tool:SetAttribute(i, v)
        end
    end

    tool.Parent = player.Backpack

    return tool
end

function inventoryServer.hasItem(_self:inventoryServer, player:Player, toolInfo:DataTemplate.StandInfo)
    local inventory = dataservice:get(player, {"Inventory"})
    local found = false
    for _, item in inventory do
        found = sift.Dictionary.equals(item, toolInfo)
        if found then
            break
        end
    end 
    return found
end

function inventoryServer.getHeldInfo(_self:inventoryServer, player:Player)
    local tool = nil :: Tool
    if player.Character then
        tool = player.Character:FindFirstChildWhichIsA("Tool")
    end
    if not tool then return end

    return dataservice:get(player, {"Inventory", tool:GetAttribute("Index")}), tool:GetAttribute("Index")
end


type inventoryServer = typeof(inventoryServer)

return inventoryServer :: inventoryServer