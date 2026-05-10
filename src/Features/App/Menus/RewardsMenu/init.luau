local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RewardButton = require(script.components.RewardButton)
local vide = require(ReplicatedStorage.Packages.vide)
local AppConstants = require(ReplicatedStorage.Shared.Features.App.Modules.AppConstants)
local AppSlice = require(ReplicatedStorage.Shared.Features.App.AppSlice)
local CameraServiceClient = require(ReplicatedStorage.Shared.Modular.Services.CameraService.CameraServiceClient)
local CenterFrame = require(ReplicatedStorage.Shared.Modular.UI.Components.Specific.CenterFrame)
local ImageIds = require(ReplicatedStorage.Shared.Modular.UI.Modules.ImageIds)

local source = vide.source

local MENU = "Rewards"

return function()
    local visible = source(false)
    AppSlice.openMenu:Connect(function(menu: string)
        if MENU == menu then
            visible(not visible())
            if not visible() then
                CameraServiceClient:tweenFOV(AppConstants.NORMAL_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
                CameraServiceClient:tweenBlur(0, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            else
                CameraServiceClient:tweenFOV(AppConstants.ZOOMED_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
                CameraServiceClient:tweenBlur(AppConstants.ZOOM_BLUR, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            end
        else
            visible(false)
        end
    end)

    local children = {}

    local SIZE = 175
    local GAP = 25
    local PER_ROW = 3
    local COLS = 4
    local ROWS = 2

    local FRAME_W = 875
    local FRAME_H = 460

    local gridW = COLS * SIZE + (COLS - 1) * GAP
    local gridH = ROWS * SIZE + (ROWS - 1) * GAP
    local startX = (FRAME_W - gridW) / 2 + SIZE/2
    local startY = (FRAME_H - gridH) / 2 + SIZE/2

    for i = 1, 6 do
        local col = (i - 1) % PER_ROW
        local row = math.floor((i - 1) / PER_ROW)

        local button = RewardButton {
            Size = UDim2.fromOffset(SIZE, SIZE),
            Position = UDim2.fromOffset(
                startX + col * (SIZE + GAP),
                startY + row * (SIZE + GAP)
            ),
            RewardIndex = i
        }

        table.insert(children, button)
    end

    local bigButton = RewardButton {
        Size = UDim2.fromOffset(SIZE, SIZE*2 + GAP),
        Position = UDim2.fromOffset(
            startX + 3 * (SIZE + GAP),
            FRAME_H / 2
        ),
        RewardIndex = 7
    }

    table.insert(children, bigButton)

    return CenterFrame {
        Name = MENU,
        MainBarColor = "Blue",
        Visible = visible,
        Icon = ImageIds.Icons.Calendar,
        Size = UDim2.fromOffset(875, 460),
        TopY = 84,
        Closed = function()
            CameraServiceClient:tweenFOV(AppConstants.NORMAL_FOV, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
            CameraServiceClient:tweenBlur(0, AppConstants.PERIOD, AppConstants.DAMPING_RATIO)
        end,
        Children = children
    }
end
