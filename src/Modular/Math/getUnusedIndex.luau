local getDictionaryLength = require(script.Parent.getDictionaryLength)
return function(tbl)
    local amount = getDictionaryLength(tbl)
    for i = 1, amount do
        if not tbl[i] then
            return i
        end
    end
    return amount + 1
end