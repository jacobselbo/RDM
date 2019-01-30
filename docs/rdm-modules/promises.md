# String Module

## API Classes

### Promise

#### Promise.New

```
Promise.New(function{resolve, reject}) -> Promiseables
```

The given function is called with a function ``resolve`` and a function ``reject``.
The function is also called in a ``coroutine`` to allow error catching and to not yield the thread.

### Promiseables

#### Promiseable.after

```
Promiseable.after(function{...}) -> Promiseables
```

When the main function ``resolve`` is called the arguments are passed down to the after function. 
You can return something in the after function for it to be dazy-chained to another after.

#### Promiseable.finally

```
Promiseable.finally(function{...}) -> Void
```

The resolves and rejects are handed down the finally function.

#### Promiseable.catch

```
Promiseable.catch([string], function{...}) -> Limited Promiseables
```

> If there isn't the given ``string`` and there isn't another dazy-chained catch with that same string then this function is called.

The first argument, ``string``, is checked against the first rejected argument. A complete and catch is returned from .catch.

#### Promiseable.complete

```
Promiseable.complete() -> Void
```

Tells the promiseable while loop that your done daizy-chaining afters.

!!! warning
	If you are ever using a ``.after`` then you have to have a ``.complete()`` at the end. 
	This is so that we don't have a constant while thread open and hogging system resources.

## Examples

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

!!! note
	This doesn't work as `https://example.com/` doesn't host roblox users, but you could make this work.