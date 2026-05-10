return function(tbl, valName, val)
    for i,v in tbl do
        if v[valName] then
            if v[valName] == val then
                return i
            end
        end
    end
    return nil
end
