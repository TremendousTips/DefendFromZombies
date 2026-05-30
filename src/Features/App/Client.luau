local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AppSlice = require(script.Parent.AppSlice)

local dataservice = require(ReplicatedStorage.Packages.dataservice).client
local appClient = {}

function appClient.init(_self:appClient)
    dataservice:getChangedSignal({"Cash"}):Connect(function(val:number)
        AppSlice.cashAmount(val)
    end)
end

type appClient = typeof(appClient)

return appClient :: appClient