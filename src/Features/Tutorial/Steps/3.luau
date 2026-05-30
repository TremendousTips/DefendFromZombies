local ReplicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(ReplicatedStorage.Packages.signal)
local InventoryClient = require(ReplicatedStorage.Shared.Features.Inventory.InventoryClient)
local TutorialSlice = require(ReplicatedStorage.Shared.Features.Tutorial.TutorialSlice)

return function()
    local completed = signal.new()

    task.wait(0.5)

    TutorialSlice.overlayVisible(true)

    TutorialSlice.overlaySize(UDim2.fromOffset(75, 75))
    TutorialSlice.overlayPosition(UDim2.new(0.5,0,1,-37))

    InventoryClient.equippedSignal:Once(function()
        TutorialSlice.overlayVisible(false)
        completed:Fire()
    end)

    return completed
end
