local COMPACT_SUFFIX = { "K", "M", "B", "T" }

return function(n: number, long: boolean?)
    if n then
        if not long then
            if n < 1000 then
                return tostring(n)
            end

            local i = 0
            while n >= 1000 and i < #COMPACT_SUFFIX do
                n /= 1000
                i += 1
            end

            local floored = math.floor(n * 10) / 10
            return tostring(floored) .. COMPACT_SUFFIX[i]
        else
            local str = tostring(math.floor(n))
            local out = ""
            local count = 0

            for i = #str, 1, -1 do
                out = str:sub(i, i) .. out
                count += 1
                if count == 3 and i ~= 1 then
                    out = "," .. out
                    count = 0
                end
            end

            return out
        end
    else
        return "0"
    end
end
