local TweenService = game:GetService("TweenService")
return function(model:Model,startingScale:number,goalScale:number, tweenInfo:TweenInfo)
    local numValue = Instance.new("NumberValue")
    numValue.Value = startingScale
    local tween = TweenService:Create(numValue, tweenInfo, {
        Value = goalScale
    })
    local connection = nil :: RBXScriptConnection
    connection = numValue.Changed:Connect(function(newValue: number)  
        model:ScaleTo(newValue)
    end)
    tween:Play()
    tween.Completed:Once(function()  
        connection:Disconnect()
        numValue:Destroy()
    end)
end
