local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM"):WaitForChild("Source")
local RDM = require(RDMF:WaitForChild("MainModule"))(script)

local players = game:GetService("Players")

local prefix = "$"
local dem = "/"

local stringUtil = RDM:Import("String")

players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if (stringUtil:Starts(prefix)) then
			local message = string.sub(message, prefix:len())
			local arguments = stringUtil:Split(message, dem)

			if (arguments[1] == "kill") then
				players[arguments[2]].Character:BreakJoints()
			end
		end
	end)
end)