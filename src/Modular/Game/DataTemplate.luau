local template = {
    Cash = 500,
    Rebirth = 0,
    Inventory = {},
    Stands = {
        [1] = {
            Type = "Empty"
        }
    },
    Upgrades = {
        Conveyer = 1,
    },
    TutorialCompleted = false
}

export type data = {
    Cash: number,
    Rebirth: number,
    Stands: {
        [number]:StandInfo
    },
    Upgrades: {
        Conveyer: number,
    },
    TutorialCompleted: boolean,
}

export type StandInfo = {
    Type: "Tower" | "Crate" | "Empty",
    Name: string?,
    Mutations: {}?,
    Cash: number?,
    Time: number?,
}

export type TowerInfo = {
    Type: "Tower",
    Name: string,
    Mutations: {},
    Cash: number?,
}

export type CrateInfo = {
    Type: "Crate",
    Name: string,
    Mutations: {},
    Time: number?,
}


return template :: data
