local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local server = {}

function server.init(self:server)
    self.networker = networker.server.new("ItemService", self)

    self.itemFunctions = {} :: {
        [string]: ((player:Player, params:any)->()),
    }
end

--[[
    Registers item giving functions
    @param item = the name of the item giving Eg: "Cash", "Pet"
    @param fn = the function for giving the item
]]
function server.registerItemFunction(self:server, item:string, fn:((player:Player, params:any)->()))
    self.itemFunctions[item] = fn
end

--[[
    gives player a specified item with params
    @param item = the name of the item giving Eg: "Cash", "Pet"
    @param params = all params needed in to give the item Eg: for cash: params = 500 <-- Amount
]]
function server.giveItem(self:server, player:Player, item:string, params:any)
    self.itemFunctions[item](player, params)
end

type server = typeof(server)

return server :: server
