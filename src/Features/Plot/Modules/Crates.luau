local MINUTE = 60
local HOUR = 60*MINUTE

return {
    ["Basic Crate"] = {
        Cost = 500,
        Weight = 10e9,
        Time = 5,
        Rarity = "Rare",
        Tower = "Turret",
        ProductId = 3516180069,
        Image = "rbxassetid://101370132259487"
    },
    ["Advanced Crate"] = {
        Cost = 5_000,
        Weight = 5e9,
        Time = 50,
        Rarity = "Epic",
        Tower = "Shotgun",
        ProductId = 3516180393,
        Image = "rbxassetid://128124100036821"
    },
    ["Enhanced Crate"] = {
        Cost = 50_000,
        Weight = 10e8,
        Time = 5*MINUTE,
        Rarity = "Legendary",
        Tower = "Flame Thrower",
        ProductId = 3516180499,
        Image = "rbxassetid://105901214791556"
    },
    ["Elite Crate"] = {
        Cost = 500_000,
        Weight = 5e8,
        Time = 20*MINUTE,
        Rarity = "Mythic",
        Tower = "Freeze Ray",
        ProductId = 3516180750,
        Image = "rbxassetid://74426306610124",
    },
    ["Mythic Crate"] = {
        Cost = 5_000_000,
        Weight = 10e7,
        Time = 1*HOUR,
        Rarity = "Godly",
        Tower = "Rocket Launcher",
        ProductId = 3516180903,
        Image = "rbxassetid://136282040980855",
    },
    ["Divine Crate"] = {
        Cost = 75_000_000,
        Weight = 5e7,
        Time = 4*HOUR,
        Rarity = "Prismatic",
        Tower = "Tesla",
        ProductId = 00000,
        Image = "rbxassetid://92026400189820"
    },
    ["LuckyBlock Crate"] = {
        Cost = 0,
        Weight = 0,
        Time = 6*HOUR,
        Rarity = "Mythic",
        Towers = {
            ["Raygun"] = 60,
            ["Ultra Raygun"] = 30,
            ["Super Ultra Raygun"] = 10,
        },
        Image = "rbxassetid://140225265722055"
    }
} :: {
    [string]: {
        Cost: number,
        Weight: number,
        Time: number,
        Rarity: string,
        Tower: string?,
        ProductId: number?,
        Image: string,
        Towers: {
            [string]: number,
        }?
    }
}