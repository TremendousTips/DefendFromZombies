local RunService = game:GetService("RunService")

return function(model: Model, target: CFrame, duration: number)
    local t = 0
    local start = model:GetPivot()
    local connection

    connection = RunService.PreRender:Connect(function(dt)
        t += dt / duration
        if t >= 1 then
            model:PivotTo(target)
            connection:Disconnect()
            return
        end

        model:PivotTo(start:Lerp(target, t))
    end)
end
