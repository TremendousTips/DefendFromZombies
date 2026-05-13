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
        Image = "rbxassetid://98773597208257",
        Rarity = "Rare",
    },
    ["Ultra Turret"] = {
        Damage = 2,
        Effect = "Shoot",
        Image = "rbxassetid://70480924535011",
        Rarity = "Epic",
    },

    ["Shotgun"] = {
        Damage = 4,
        Effect = "Shoot",
        Image = "rbxassetid://76647106409748",
        Rarity = "Epic",
    },
    ["Ultra Shotgun"] = {
        Damage = 8,
        Effect = "Shoot",
        Image = "rbxassetid://84132240089162",
        Rarity = "Legendary",
    },

    ["Flame Thrower"] = {
        Damage = 12,
        Effect = "Shoot",
        Image = "rbxassetid://112126607428169",
        Rarity = "Legendary",
    },
    ["Ultra Flame Thrower"] = {
        Damage = 24,
        Effect = "Shoot",
        Image = "rbxassetid://94452286227283",
        Rarity = "Mythic",
    },

    ["Freeze Ray"] = {
        Damage = 40,
        Effect = "Shoot",
        Image = "rbxassetid://73965591590234",
        Rarity = "Mythic",
    },
    ["Ultra Freeze Ray"] = {
        Damage = 80,
        Effect = "Shoot",
        Image = "rbxassetid://115846789758003",
        Rarity = "Godly",
    },

    ["Rocket Launcher"] = {
        Damage = 150,
        Effect = "Shoot",
        Image = "rbxassetid://121202425118362",
        Rarity = "Godly",
    },
    ["Ultra Rocket Launcher"] = {
        Damage = 300,
        Effect = "Shoot",
        Image = "rbxassetid://107974818285707",
        Rarity = "Secret",
    },

    ["Tesla"] = {
        Damage = 600,
        Effect = "Shoot",
        Image = "rbxassetid://119687449627216",
        Rarity = "Secret",
    },
    ["Ultra Tesla"] = {
        Damage = 1200,
        Effect = "Shoot",
        Image = "rbxassetid://93011136739726",
        Rarity = "Secret",
    },
    ["Raygun"] = {
        Damage = 250,
        Effect = "Shoot",
        Image = "rbxassetid://81636004046151",
        Rarity = "Epic",
    },
    ["Ultra Raygun"] = {
        Damage = 500,
        Effect = "Shoot",
        Image = "rbxassetid://79276859438300",
        Rarity = "Legendary",
    },
    ["Super Ultra Raygun"] = {
        Damage = 750,
        Effect = "Shoot",
        Image = "rbxassetid://98555479077190",
        Rarity = "Mythic",
    },

    
}

return tbl :: {[string]:tower}
    