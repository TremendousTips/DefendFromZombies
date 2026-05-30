local MIN = 60
local HOUR = 60*MIN
local DAY = 24*HOUR
return {
    [MIN*10] = {
        ProductId = 3513169056,
    },
    [MIN*30] = {
        ProductId = 3600968297,
    },
    [HOUR] = {
        ProductId = 3600968779,
    },
    [HOUR*12] = {
        ProductId = 3600969111,
    },
    [DAY] = {
        ProductId = 3600969228,
    }
} :: {
    [number]: {
        ProductId: number,
    }
}