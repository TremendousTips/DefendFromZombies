local utils = {}

function utils.getBoostSum(_self:utils, tbl)
    local total = 0
    for _, source:number in tbl do
        source += total
    end
end

type utils = typeof(utils)

return utils :: utils