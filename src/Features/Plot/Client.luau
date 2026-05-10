local ReplicatedStorage = game:GetService("ReplicatedStorage")
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local DataTemplate = require(ReplicatedStorage.Shared.Modular.Game.DataTemplate)
local client = {}

type client = typeof(client)

function client.init(self:client)
    self.networker = networker.client.new("plotFeature", self)

    self.plots = {}

    self.playerStands = {} :: {
        [number]: {
            [number]: DataTemplate.TowerInfo | DataTemplate.CrateInfo
        }
    }

    self.playerChangedSignals = {} :: {
        [number]: signal.Signal<>
    }
end

function client.playerAdded(self:client, player:Player, stands)
    self.playerStands[player.UserId] = stands
    self.playerChangedSignals[player.UserId] = signal.new()
end

function client.playerRemoved(self:client, player:Player)
    self.playerStands[player.UserId] = nil
    self.playerChangedSignals[player.UserId]:Destroy()
end

function client.get(self:client, player:Player)
    return self.playerStands[player.UserId]
end

function client.getChanged(self:client, player:Player)
    return self.playerChangedSignals[player.UserId]
end

function client.changePlayerStands(self:client, player:Player, stands)
    self.playerStands[player.UserId] = stands
    self.playerChangedSignals[player.UserId]:Fire(stands)
end

return client :: client