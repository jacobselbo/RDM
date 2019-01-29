local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM")
local RDM = require(RDMF:WaitForChild("MainModule"))(script)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Promise = RDM:Import("Promise")

local baseUrl = "https://example.com/"

local function getData(player)
	return Promise:New(function(resolve, reject)
		local response = HttpService:RequestAsync({
			["Url"] = string.format(baseUrl .. "/users/%d", player.UserId),
			["Method"] = "GET"
		})

		if (response["Success"]) then
			resolve(response["Body"])
		else
			reject(response["StatusCode"], response["StatusMessage"])
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	getData(player):after(function(body)
		return HttpService:JSONDecode(body)
	end):after(function(playerData)
		if (playerData["Banned"]) then
			player:Kick(playerData["BanMessage"])
		end
	end):catch(function(statusCode, message)
		error("Unexpected error: " .. statusCode .. " | " .. message)
	end):complete()
end)