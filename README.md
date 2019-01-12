<h1 align="center">Roblox Dependency Manager</h1>
<div align="center">
	<a href="https://discord.gg/mrVC9dr">
		<img src="https://discordapp.com/api/guilds/526532172501221396/widget.png" alt="Discord" />
	</a>
	<a href="https://github.com/froghopperjacob/RDM/tree/master/LICENSE">
		<img src="https://img.shields.io/badge/License-Apache%202.0-lightgrey.svg" alt="Lisence" />
	</a>
</div>

<div align="center">
	RDM is a small and light weight dependency manager that is setup like <a href="https://github.com/npm/cli"> NPM </a>.
</div>

<div>&nbsp;</div>

## Index

1. [Examples](#examples)
2. [Documentation)(#documentation)
3. [Download](#download)

## Examples

**Using String Module**
```lua
local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM"):WaitForChild("Source")
local RDM = require(RDMF:WaitForChild("MainModule"))(script)

local players = game:GetService("Players")

local prefix = "$"
local dem = "/"

local stringUtil = RDM:Import("String")

players.PlayerAdded:Connect(function(player)
	player.Chatted:connect(function(message)
		if (stringUtil:Starts(prefix)) then
			local message = string.sub(message, 1)
			local arguments = stringUtil:Split(message, dem)
			
			if (arguments[0] == "kill") then
				players[arguments[1]].Character:BreakJoints()
			end
		end
	end)
end)
```

## Download

There are mutiple ways of downloading RDM and installing packages.

**Download through Packages**

This is probably the best method of downloading since you will have a constantly updated package.

1. Go to [Package](https://www.roblox.com/library/2737448764/RDM-Roblox-Dependency-Manager)
2. Add to inventory
3. Go to toolbox and head to `My Packages` 
4. Add `RDM - Roblox Dependency Manager` to `ServerScriptService`

**Download through Github**

Run 
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/tree/master/Install.lua"))()
```
in the command bar.

# Alot of this is in a Todo phase so wait a bit
