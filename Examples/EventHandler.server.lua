local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM")
local RDM = require(RDMF:WaitForChild("MainModule"))(script)

local EventHandler = RDM:Import("EventHandler")

local Remotes = game:GetService("ReplicatedStorage")
local remoteEvent = Remotes:WaitForChild("Event")

remoteEvent.OnClientEvent:Connect(function(command, ...)
	EventHandler:Emit(command, ...)
end)

EventHandler:Connect("Instance", function(instanceClass, properties)
	local newClass = Instance.new(instanceClass)

	for key, value in pairs(properties) do
		newClass[key] = value
	end
end)