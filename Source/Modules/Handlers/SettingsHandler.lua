local configFolder = script.Parent.Parent.Parent:WaitForChild("Configuration")
local RDMSettings = require(configFolder:WaitForChild("Config"))

return {
	["Init"] = function(baseClass, prereqs)
		return baseClass:Extend(
			{
				["Get"] = function(setting)
					local RDMSetting = RDMSettings[setting]
					
					if (RDMSetting == nil) then
						return error("Invalid setting given. Got: " .. setting)	
					end
					
					return RDMSetting
				end,
				
				["Set"] = function(setting, newValue)
					local RDMSetting = RDMSettings[setting]
					
					if (RDMSetting == nil) then
						return error("Invalid setting given. Got: " .. setting)
					end 
					
					RDMSettings[setting] = newValue
					
					return true
				end
			}
		)
	end,
	
	["Prerequisites"] = { }
}