<h1 align="center">Roblox Dependency Manager</h1>
<div align="center">
	<a href="https://discord.gg/mrVC9dr">
		<img src="https://discordapp.com/api/guilds/526532172501221396/widget.png" alt="Discord" />
	</a>
	<a href="https://github.com/froghopperjacob/RDM/tree/master/LICENSE">
		<img src="https://img.shields.io/badge/License-Apache%202.0-lightgrey.svg" alt="Lisence" />
	</a>
	<a href="https://travis-ci.org/froghopperjacob/RDM">
		<img src="https://travis-ci.org/froghopperjacob/RDM.svg?branch=master" alt="Travis" />
	</a>
	<a href="https://coveralls.io/github/froghopperjacob/RDM?branch=master">
		<img src="https://coveralls.io/repos/github/froghopperjacob/RDM/badge.svg?branch=master" alt="Coverage Status" />
	</a>
</div>

<div align="center">
	RDM is a small and light weight dependency manager that is setup like <a href="https://github.com/npm/cli">NPM</a>.
</div>

<div>&nbsp;</div>

## Index

1. [Examples](#examples)
2. [Documentation](#documentation)
3. [Download](#download)
4. [Installing Packages](#installing-packages)
5. [Creating Packages](#creating-packages)
6. [How to Contribute](#how-to-contribute)

## Examples

**Using String Module**
```lua
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
```

## Download



**Download through Packages**

This is probably the best method of downloading since you will have a constantly updated package.

1. Head to [RDM Package](https://www.roblox.com/library/2737448764/RDM-Roblox-Dependency-Manager)
2. Add to inventory
3. Go to toolbox and head to `My Packages` 
4. Add `RDM - Roblox Dependency Manager` to your wanted location

**Download through Github**
*Note this is note been made yet*

Run in the command bar. If you want RDM to not be placed in `ServerScriptService` then where it calls the loadstring put the destination you want. If you want all of RDM then put true for the second argument.

*Normally*
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/tree/master/Install.lua"))()
```
*Edited destination*
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/tree/master/Install.lua"))(game:GetService("ServerStorage"))
```

*All of RDM*
```lua
local h = game:GetService("HttpService"); h.HttpEnabled = true; loadstring(h:GetAsync("https://raw.githubusercontent.com/froghopperjacob/RDM/tree/master/Install.lua"))(null, true)
```

## Installing Packages

There are two methods of installing packages. The most recommended way of installing packages is locally and not at runtime.

**Installing Packages Locally**

There is also two methods of installing packages locally.

*Installing through script*




# Alot of this is in a Todo phase so wait a bit
