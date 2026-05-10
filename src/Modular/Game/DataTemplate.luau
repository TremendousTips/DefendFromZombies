local template = {
    Cash = 0,
}

export type data = {
    Cash:number,
    Stands: {
        [number]:TowerInfo|CrateInfo
    }
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
