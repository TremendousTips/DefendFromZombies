local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local BackgroundMusic = require(ReplicatedStorage.Shared.Modular.Services.SoundService.Modules.BackgroundMusic)
local SoundIds = require(ReplicatedStorage.Shared.Modular.Services.SoundService.Modules.SoundIds)

local client = {}

function client.init(self:client)

    self.sounds = {} :: {
        [string]:Sound
    }


    local backgroundMusic = Instance.new("Sound")
    backgroundMusic.Parent = SoundService
    task.spawn(function()
        for i, v in SoundIds do
            self.sounds[i] = Instance.new("Sound")
            self.sounds[i].Parent = SoundService
            self.sounds[i].SoundId = v
        end
        while true do
            for _, id in BackgroundMusic do
                backgroundMusic.SoundId = id
                backgroundMusic.Volume = .1
                backgroundMusic:Play()
                backgroundMusic.Ended:Wait()
            end
        end
    end)
end

type playInfo = {
    i:string, e:string?, p:{}?
}

function client.play(self:client, sound:string, props:{}?)
    local identifier = sound
    local i = identifier
    if not self.sounds[i] then
        self.sounds[i] = Instance.new("Sound")
        self.sounds[i].Parent = SoundService
        self.sounds[i].SoundId = SoundIds[identifier]
    end
    if props then
        for x, v in props do
            self.sounds[identifier][x] = v
        end
    end
    self.sounds[i]:Play()
end

function client.stop(self:client, identifier:string)
    if self.sounds[identifier] then
        self.sounds[identifier]:Stop()
    end
end

type client = typeof(client)

return client :: client