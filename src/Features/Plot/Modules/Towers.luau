export type tower = {
    Damage: number,
    Effect: string,
    Image: string,
    Rarity: string,
}

local tbl = {
    ["Turret"] = {
        Damage = 1,
        Effect = "Shoot",
        Image = "rbxassetid://108116526686895",
        Rarity = "Rare",
    },
    ["Ultra Turret"] = {
        Damage = 2,
        Effect = "Shoot",
        Image = "rbxassetid://71819794516987",
        Rarity = "Epic",
    },

    ["Shotgun"] = {
        Damage = 4,
        Effect = "Shoot",
        Image = "rbxassetid://100091463245274",
        Rarity = "Epic",
    },
    ["Ultra Shotgun"] = {
        Damage = 8,
        Effect = "Shoot",
        Image = "rbxassetid://118840564917024",
        Rarity = "Legendary",
    },

    ["Flame Thrower"] = {
        Damage = 12,
        Effect = "Shoot",
        Image = "rbxassetid://102576995674170",
        Rarity = "Legendary",
    },
    ["Ultra Flame Thrower"] = {
        Damage = 24,
        Effect = "Shoot",
        Image = "rbxassetid://137849473288752",
        Rarity = "Mythic",
    },

    ["Freeze Ray"] = {
        Damage = 40,
        Effect = "Shoot",
        Image = "rbxassetid://92073792317277",
        Rarity = "Mythic",
    },
    ["Ultra Freeze Ray"] = {
        Damage = 80,
        Effect = "Shoot",
        Image = "rbxassetid://73255852711782",
        Rarity = "Godly",
    },

    ["Rocket Launcher"] = {
        Damage = 150,
        Effect = "Shoot",
        Image = "rbxassetid://85401156500648",
        Rarity = "Godly",
    },
    ["Ultra Rocket Launcher"] = {
        Damage = 300,
        Effect = "Shoot",
        Image = "rbxassetid://83562106749509",
        Rarity = "Secret",
    },

    ["Tesla"] = {
        Damage = 600,
        Effect = "Shoot",
        Image = "rbxassetid://125448879668791",
        Rarity = "Secret",
    },
    ["Ultra Tesla"] = {
        Damage = 1200,
        Effect = "Shoot",
        Image = "rbxassetid://98657039394303",
        Rarity = "Secret",
    },
    ["Raygun"] = {
        Damage = 250,
        Effect = "Shoot",
        Image = "rbxassetid://110260459430234",
        Rarity = "Epic",
    },
    ["Ultra Raygun"] = {
        Damage = 500,
        Effect = "Shoot",
        Image = "rbxassetid://132696470427474",
        Rarity = "Legendary",
    },
    ["Super Ultra Raygun"] = {
        Damage = 750,
        Effect = "Shoot",
        Image = "rbxassetid://127665697951965",
        Rarity = "Mythic",
    },

    
}

return tbl :: {[string]:tower}
    