# String Module

## API Classes

### EventHandler

#### EventHandler.Connect

```lua
EventHandler.Connect(eventName, function) -> Event
```

This creates a new event and connects a function to that event.

#### EventHandler:Emit

```lua
EventHandler:Emit(eventName, ...) -> Void
```

This calls every function associated with that eventName with the given arguements.

!!! note
	You have to use the : format instead of the . format for this function. 
	This is because it would be to complicated to move all arguemnts down a variable

#### EventHandler.Register

```lua
EventHandler.Register(eventName) -> Event
```

This creates a new standalone event. This is useful if you want to return a event that someone can connect to.

### Event

#### Event:Emit

```lua
Event:Emit(...) -> Void
```

Calls every function associated with the parent's Event.

!!! note
	You have to use the : format instead of the . format for this function. 
	This is because it would be to complicated to move all arguemnts down a variable

#### Event.Disconnect

```lua
Event.Disconnect() -> Void
```

Completly kills the entire event and all child functions.

#### Event.Connect

```lua
Event.Connect(function{...}) -> Event
```

Adds a new function to the parent Event. This returns a Event so that you can dazy-chain Connects if you wanted to.

## Examples

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