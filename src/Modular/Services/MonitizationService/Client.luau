local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local client = {}

local player = Players.LocalPlayer

--[[
    Initializes the MonitizationService client and connects to the server networker.
]]
function client.init(self:client)
    self.networker = networker.client.new("Monitization", self)
end

--[[
    Prompts the local player to purchase a game pass.
    @param gamePassId = game pass asset id Eg: 123456789
]]
function client.promptPass(_self:client, gamePassId:number)
    MarketplaceService:PromptGamePassPurchase(player, gamePassId)
end

--[[
    Prompts the local player to purchase a developer product, optionally passing extra info to the server.
    @param productId = developer product asset id Eg: 987654321
    @param extraInfo = optional extra data forwarded to the server purchase handler
]]
function client.promptProduct(self:client, productId:number, extraInfo:any?)
    self.networker:fire("updateExtraInfo", extraInfo)
    MarketplaceService:PromptProductPurchase(player, productId)
end

--[[
    Returns the Robux price of a developer product.
    @param productId = developer product asset id Eg: 987654321
    @return number Eg: 50, 100, 500
]]
function client.getProductPrice(_self:client, productId:number)
    return MarketplaceService:GetProductInfoAsync(productId, Enum.InfoType.Product).PriceInRobux
end

--[[
    Returns the Robux price of a game pass.
    @param passId = game pass asset id Eg: 123456789
    @return number Eg: 199, 499, 999
]]
function client.getGamepassPrice(_self:client, passId:number)
    return MarketplaceService:GetProductInfoAsync(passId, Enum.InfoType.GamePass).PriceInRobux
end

type client = typeof(client)

return client :: client