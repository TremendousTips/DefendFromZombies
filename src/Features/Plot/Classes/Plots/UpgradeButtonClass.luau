local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotButton = require(script.Parent.PlotButton)
local UpgradesSlice = require(ReplicatedStorage.Shared.Features.Upgrades.UpgradesSlice)
local upgradeButtonClass = {}
upgradeButtonClass.__index = upgradeButtonClass

type props = {
    Upgrade: string,
    CFrame:CFrame,
}

local parent = Instance.new("Folder")
parent.Name = "UpgradeButtons"
parent.Parent = game.Workspace

function upgradeButtonClass.create(props:props)
    local self = setmetatable({}, upgradeButtonClass)
    local model = ReplicatedStorage.Assets.UpgradeButton:Clone() :: Model
    model.Parent = parent
    model:PivotTo(props.CFrame)

    PlotButton {
        Model = model,
        Activated = function()
            UpgradesSlice.requestUpgrade:Fire(props.Upgrade)
        end
    }

    return self
end

return upgradeButtonClass