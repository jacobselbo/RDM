local configFolder = script.Parent.Parent.Parent:WaitForChild("Configuration")
local RDMSettings = require(configFolder:WaitForChild("Config"))

return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local LogHandler = prereqs["LogHandler"]

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Get"] = function(setting)
					local RDMSetting = RDMSettings[setting]

					if (RDMSetting == nil) then
						return not LogHandler:Log("High", true,
							"Invalid setting given", nil,
							"LocalModules",
							setting)
					end

					return RDMSetting
				end,

				["Set"] = function(setting, newValue)
					local RDMSetting = RDMSettings[setting]

					if (RDMSetting == nil) then
						return not LogHandler:Log("High", true,
							"Invalid setting given", nil,
							"LocalModules",
							setting)
					end

					RDMSettings[setting] = newValue

					return true
				end
			}
		)
	end,

	["Prerequisites"] = { "LogHandler" }
}