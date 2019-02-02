local defaults = {
	["Core"] = {
		["Name"] = "RDM",
		["Location"] = nil
	},

	["Websites"] = {
		
	}
}

return {
	["Init"] = function(baseClass, prereqs)
		return baseClass:Extend(
			{
				["Get"] = function(self, category, name)
					if (name == nil) then
						return defaults[category]
					end

					local tryGet = plugin:GetSetting(name)

					if (not tryGet or tryGet == nil) then
						if (defaults[category][name] ~= nil) then
							local defaultGot = defaults[category][name]

							plugin:SetSetting(name, defualtGot)

							return defualtGot
						else
							return false
						end
					end

					return tryGet
				end,

				["Set"] = function(self, category, name, value)
					plugin:SetSetting(name, value or defaults[category][name])
				end
			}
		)
	end,

	["Prerequisites"] = { }
}