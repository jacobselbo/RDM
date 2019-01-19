local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM")
local RDM = require(RDMF:WaitForChild("MainModule"))()

local players = game:GetService("Players")

local prefix = "$"
local dem = "/"

local stringUtil = RDM:Import("String")

players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if (stringUtil:Starts(message, prefix)) then
			local message = string.sub(message, prefix:len())
			local arguments = stringUtil:Split(message, dem)

			if (arguments[1] == "kill") then
				players[arguments[2]].Character:BreakJoints()
			end
		end
	end)
end)