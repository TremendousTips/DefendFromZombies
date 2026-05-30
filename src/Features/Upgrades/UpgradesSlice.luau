local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)

local requestUpgrade = signal.new() :: signal.Signal<string>

return {
    requestUpgrade = requestUpgrade
}