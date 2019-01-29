# String Module

## API Refrence

### String.Starts

```lua
String.Starts(string, startsWith) -> Boolean
```

Checks if the given ``string`` starts with the ``startsWith``string.

### String.Ends

```lua
String.Ends(string, endsWith) -> Boolean
```

Checks if the given ``string`` ends with the ``endsWith``string.

### String.Trim

```lua
String.Trim(string) -> String
```

Trims ending and starting whitespaces of the given ``string``.


### String.Join

```lua
String.Join(fields, [join]) -> String
```
> Join Default: ``, ``

Takes in a Array of characters (``fields``) with an optional ``join`` string. 
Each character is added to the string and the ``join``. 
The last index doesn't have the ``join`` string added.

### String.Split

```lua
String.Split(string, [seperator]) -> Array
```

> Seperator Default: ""

The function Split, splits the string with a optional ``seperator`` string into a array of characters

### String.Count

```lua
String.Count(string, counterString) -> Number
```

Counts the number of occurences from ``counterString`` in the ``string``.

### String.IsLower

```lua
String.IsLower(string) -> Boolean
```

Checks if the entire string is all lowercase.

### String.IsUpper

```lua
String.IsUpper(string) -> Boolean
```

Checks if the entire string is all uppercase.

### String.EncodeHTML

```lua
String.EncodeHTML(string) -> String
```

Turns the given ``string`` into a HTML readable format.

### String.DecodeHTMLEntities

```lua
String.DecodeHTMLEntities(encodedHTML) -> String
```

Turns the given ``encodedHTML`` into a normal string.

### String.DecodeURL

```lua
String.DecodeURL(URLEncoded) -> String
```

Converts the ``UrlEncode`` string into a normal string.

### String.ToBoolean

```lua
String.ToBoolean(string) -> Boolean
```

Checks the given ``string`` to see if it equal to the following strings:

> true, on, 1, yes

## Examples

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

!!! note
	Use a more modular command system if your actually going to implement this.