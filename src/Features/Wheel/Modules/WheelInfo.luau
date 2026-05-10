local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TrailInfo = require(ReplicatedStorage.Shared.Features.Trails.Modules.TrailInfo)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)
local tbl = {
    [1] = {
        Percentage = 18,
        TopText = "+5 Wins",
        Icon = ImageIds.Icons.Trophy,
        Reward = {
            Type = "Wins",
            Params = 5,
        }
    },
    [2] = {
        Percentage = 17.5,
        TopText = "+200 Coins",
        Icon = ImageIds.Tiers.Cash[1],
        Reward = {
            Type = "Cash",
            Params = 200,
        }
    },
    [3] = {
        Percentage = 4,
        TopText = "Inferno Trail",
        Icon = TrailInfo.Inferno.Icon,
        Reward = {
            Type = "Trail",
            Params = "Inferno",
        }
    },
    [4] = {
        Percentage = 12,
        TopText = "+50 Wins",
        Icon = ImageIds.Icons.Trophy,
        Reward = {
            Type = "Wins",
            Params = 50,
        }
    },
    [5] = {
        Percentage = 22.5,
        TopText = "+10 Coins",
        Icon = ImageIds.Icons.Cash,
        Reward = {
            Type = "Cash",
            Params = 10,
        }
    },
    [6] = {
        Percentage = 12.5,
        TopText = "2x CASH Boost",
        Icon = ImageIds.Potions.CashPotion,
        Reward = {
            Type = "Boost",
            Params = {
                Name = "Cash",
                Time = 60*5
            },
        }
    },
    [7] = {
        
        Percentage = 1,
        TopText = "Celestial Trail 99x BOOST",
        Icon = TrailInfo.Celestial.Icon,
        Reward = {
            Type = "Trail",
            Params = "Celestial",
        }
    },
    [8] = {
        Percentage = 12.5,
        TopText = "2x SPEED Boost",
        Icon = ImageIds.Potions.SpeedPotion,
        Reward = {
            Type = "Boost",
            Params = {
                Name = "Speed",
                Time = 60*5
            },
        }
    },
}

for _, item in tbl do
    item.Weight = item.Percentage / 100
end

return tbl