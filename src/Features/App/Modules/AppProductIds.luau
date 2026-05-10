local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)
return {
    BoostNitro = {
        ProductId = 3586940833,
        Type = "DoubleNitro",
        Params = {},
    },
    CashPotion = {
        ProductId = 3585777573,
        Type = "Boost",
        Params = {
            Name = "Cash",
            Time = 5*60,
        },
    },
    SpeedPotion = {
        ProductId = 3585777217,
        Type = "Boost",
        Params = {
            Name = "Speed",
            Time = 5*60,
        },
    },
    WinsPotion = {
        ProductId = 3585776796,
        Type = "Boost",
        Params = {
            Name = "Wins",
            Time = 5*60,
        },
    },
    Starterpack = {
        ProductId = 3585742569,
        Type = "Pack",
        Params = {
            [1] = {
                Icon = ImageIds.Icons.Wheel,
                Text = "+5 Spins",
                Type = "Spins",
                Params = 5,
            },
            [2] = {
                Icon = ImageIds.Tiers.Cash[2],
                Text = "+$1,000 Cash",
                Type = "Cash",
                Params = 1000,
            },
            [3] = {
                Icon = ImageIds.Icons.Trophy,
                Text = "+100 Wins",
                Type = "Wins",
                Params = 100,
            }
        }
    }
}