<h1 align="center">Roblox Dependency Manager</h1>
<div align="center">
	<a href="https://discord.gg/mrVC9dr">
		<img src="https://img.shields.io/discord/526532172501221396.svg?colorB=blue&label=discord&logo=discord&style=flat-square" alt="Discord" />
	</a>
	<a href="https://github.com/froghopperjacob/RDM/tree/master/LICENSE">
		<img src="https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg?style=flat-square" alt="Lisence" />
	</a>
	<a href="https://travis-ci.org/froghopperjacob/RDM">
		<img src="https://img.shields.io/travis/froghopperjacob/RDM/master.svg?style=flat-square" alt="Travis" />
	</a>
	<a href="https://coveralls.io/github/froghopperjacob/RDM?branch=master">
		<img src="https://img.shields.io/coveralls/github/froghopperjacob/RDM.svg?style=flat-square" alt="Coveralls" />
	</a>
	<a href="https://froghopperjacob.github.io/RDM/">
		<img src="https://img.shields.io/badge/docs-website-lightblue.svg?style=flat-square" alt="Documentation" />
	</a>
</div>

<div align="center">
	RDM is a small and light weight dependency manager that is setup like <a href="https://github.com/npm/cli">NPM</a>.
</div>

<div align="center">
	<b>⚠️ RDM should only be used for experimental projects until v1.0.0 ⚠️</b>
</div>

<div>&nbsp;</div>

## Index

1. [Examples](#examples)
2. [Documentation](https://froghopperjacob.github.io/RDM/)
3. [Download](#download)
4. [Installing Packages](#installing-packages)
5. [Creating Packages](#creating-packages)
6. [How to Contribute](#how-to-contribute)

## Examples

**Using String Module**
```lua
local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM")
local RDM = require(RDMF:WaitForChild("MainModule"))(script)

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
```

**Using Promise Module**
```lua
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
```

**Using Event Handler Module**
```lua
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
```

## Download

**Download through Packages**

This is probably the best method of downloading since you will have a constantly updated package.

1. Head to [RDM Package](https://www.roblox.com/library/2737448764/RDM-Roblox-Dependency-Manager)
2. Add to inventory
3. Go to toolbox and head to `My Packages` 
4. Add `RDM - Roblox Dependency Manager` to your wanted location

**Download through Github**

Run in the command bar. If you want RDM to not be placed in `ServerScriptService` then where it calls the loadstring put the destination you want. If you want all of RDM then put true for the second argument.

*Normally*
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/master/install.lua"))()
```
*Edited destination*
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/master/install.lua"))(game:GetService("ServerStorage"))
```

*All of RDM*
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/master/install.lua"))(null, true)
```

## Installing Packages

There are two methods of installing packages. The most recommended way of installing packages is locally and not at runtime.

**Installing Packages Locally**

There is also two methods of installing packages locally.

*Installing through script*
