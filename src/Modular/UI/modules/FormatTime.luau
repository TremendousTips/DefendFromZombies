return function(seconds:number)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    local secs = seconds % 60
    if hours >= 1 then
        return string.format("%02d:%02d:%02d", hours, (minutes - (60*hours)), secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end