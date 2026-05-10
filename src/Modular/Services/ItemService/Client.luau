local client = {}

--[[
    Initializes the ItemService client and sets up the items table.
]]
function client.init(self:client)
    self.itemsTable = {} :: {
        [string]: {}
    }
end

--[[
    Registers a table of items under a given key.
    @param i = table key Eg: "Swords", "Pets"
    @param v = table of item data to store under that key
]]
function client.registerItems(self:client, i, v)
    self.itemsTable[i] = v
end

--[[
    Looks up an item by name across all registered item tables and returns an itemType accessor object.
    @param name = item's name Eg: "IronSword", "FirePet"
    @return itemType object with getWeight/getTopText/getTopGradient/getBottomText/getBottomGradient/getIcon/getOdds/getRarity, or nil if not found
]]
function client.getItem(self:client, name:string)
    local item = nil
    
    for _, tbl in self.itemsTable do
        if tbl[name] then
            item = tbl[name]
            break
        end
    end

    if item then
        local itemType = {}

        itemType.getWeight = function()
            return item.Weight or 0 :: number
        end

        itemType.getTopText = function()
            return item.TopText or "No Top Text" :: string
        end

        itemType.getTopGradient = function()
            return item.TopGradient or ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)) :: ColorSequence
        end

        itemType.getBottomText = function()
            return item.BottomText or "No Bottom Text" :: string
        end

        itemType.getBottomGradient = function()
            return item.BottomGradient or ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)) :: ColorSequence
        end

        itemType.getIcon = function()
            return item.Icon or "" :: string            
        end

        itemType.getOdds = function()
            return item.Odds or "1/1" :: string
        end

        itemType.getRarity = function()
            return item.Rarity or "Common"
        end

        return itemType :: {
            getWeight: (()->(number)),
            getTopText: (()->(string)),
            getTopGradient: (()->(ColorSequence)),
            getBottomText: (()->(string)),
            getBottomGradient: (()->(ColorSequence)),
            getIcon: (()->(string)),
            getOdds: (()->(string)),
            getRarity: (()->(string))
        }
    else
        return nil
    end
end

type client = typeof(client)

return client :: client