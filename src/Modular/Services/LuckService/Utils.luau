local utils = {}

type tbl = {
	[string]: {
		Weight: number,
	}
}

--[[
	Gets a random item key from a weighted table, influenced by luck.
	@param tbl   - table of items with a Weight field
	@param luck  - luck multiplier as a percentage (e.g. 100 = default, 200 = double)

	```lua
	local name = LuckServiceUtils.getWeightedRandom(Brainrots, 100)
	```
]]
function utils.getWeightedRandom(tbl: tbl, luck: number): string
	local totalWeight = 0
	for _, info in tbl do
		totalWeight += info.Weight
	end

	local sorted = {}
	for id, info in tbl do
		table.insert(sorted, { id = id, odds = info.Weight / totalWeight })
	end
	table.sort(sorted, function(a, b) return a.odds > b.odds end)

	local roll = math.random()
	local sum  = 0
	for i = #sorted, 1, -1 do
		local item   = sorted[i]
		local chance = 1 - (1 - item.odds) ^ (luck / 100)
		sum += chance
		if roll <= sum then
			return item.id
		end
	end

	return sorted[1].id
end

type utils = typeof(utils)

return utils :: utils
