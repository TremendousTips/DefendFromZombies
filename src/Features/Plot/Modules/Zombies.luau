local zombies = {}

function zombies.getHealthFromLevel(_self:zombies, level:number)
    return 50^level
end

type zombies = typeof(zombies)

return zombies :: zombies