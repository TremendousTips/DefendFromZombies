local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RewardInfo = require(ReplicatedStorage.Shared.Features.Rewards.Modules.RewardInfo)
local RewardsSlice = require(ReplicatedStorage.Shared.Features.Rewards.RewardsSlice)
local TextLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Advanced.TextLabel)
local ImageLabel = require(ReplicatedStorage.Shared.Modular.UI.Components.Foundational.ImageLabel)
local StudButton = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.StudButton)
type props = {
    Size: UDim2,
    Position: UDim2,
    RewardIndex: number,
}

return function(props:props)
    return StudButton {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = Vector2.new(0.5,0.5),
        Color = RewardInfo[props.RewardIndex].Color,
        Activated = function()
            RewardsSlice.requestReward:Fire(props.RewardIndex)
        end,
        Children = {
            ImageLabel {
                Name = "Icon",
                Size = UDim2.fromScale(0.8, 0.8),
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Image = RewardInfo[props.RewardIndex].Icon
            },
            TextLabel {
                Name = "Day",
                Size = UDim2.fromScale(0.8, 0.2),
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0),
                StrokeThickness = 3,
                Text = `Day {props.RewardIndex}`,
            },
            TextLabel {
                Name = "Info",
                Size = UDim2.fromScale(0.8, 0.15),
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, .75),
                StrokeThickness = 3,
                Text = RewardInfo[props.RewardIndex].BottomText,
            },
            TextLabel {
                Name = "ClaimedOrTime",
                Size = UDim2.fromScale(0.8, 0.2),
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 1),
                StrokeThickness = 3,
                Text = function()
                    local idx = props.RewardIndex
                    local claimed = RewardsSlice.claimedIndexes()
                    if claimed[idx] then
                        return "Claimed"
                    end
                    local cooldown = (idx - 1) * 86400
                    local remaining
                    if idx > 1 and not claimed[idx - 1] then
                        remaining = cooldown
                    else
                        remaining = math.max(0, RewardsSlice.lastClaimTime() + cooldown - RewardsSlice.now())
                    end
                    if remaining >= 86400 then
                        local days = math.floor(remaining / 86400)
                        return `{days} day{days == 1 and "" or "s"}`
                    end
                    if remaining <= 0 then
                        return "Claim!"
                    end
                    local hours = math.floor(remaining / 3600)
                    local minutes = math.floor((remaining % 3600) / 60)
                    local seconds = remaining % 60
                    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
                end,
            },
        }
    }
end
