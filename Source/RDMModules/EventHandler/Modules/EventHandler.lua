local events = { }

local function generate(baseClass, RDM, name, event, func)
	return baseClass:Extend(
		{
			["Emit"] = function(self, ...)
				if (self["Disconnect"] ~= nil) then
					return RDM:Log("High", true, "Call catch with a : instead of a .",
						name, ":", ".")
				end

				for _, func in pairs(events[event]) do
					func(...)
				end
			end,

			["Disconnect"] = function(self)
				if (func) then
					events[event][func] = nil
				end
			end,

			["Connect"] = function(self, func)
				if (type(self) ~= "table") then
					func = self
				end

				if (type(func) ~= "function") then
					return RDM:Log("High", true, "The first argument of Connect has to be a function.",
						name, "function", type(func))
				end

				if (not events[event]) then
					events[event] = { }
				end

				events[event][func] = func

				return generate(baseClass, RDM, name, event, func)
			end
		}
	)
end

return {
	["Init"] = function(baseClass, prereqs, RDM)
		-- [[ Constants ]] --

		local package = require(script.Parent.Parent.Package)
		local name = package["Name"]

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Connect"] = function(self, eventName, func)
					if (type(self) ~= "table") then
						eventName, func = self, eventName
					end

					if (type(eventName) ~= "string") then
						return RDM:Log("High", true, "The first argument of Connect has to be a string.",
							name, "string", type(eventName))
					end

					if (type(func) ~= "function") then
						return RDM:Log("High", true, "The second argument of Connect has to be a function.",
							name, "function", type(func))
					end

					if (not events[eventName]) then
						events[eventName] = { }
					end

					events[eventName][func] = func

					return generate(baseClass, RDM, name, eventName, func)
				end,

				["Emit"]  = function(self, eventName, ...)
					if (type(self) ~= "table") then
						return RDM:Log("High", true, "Call catch with a : instead of a .",
							name, ":", ".")
					end

					if (type(eventName) ~= "string") then
						return RDM:Log("High", true, "The first argument of Connect has to be a string.",
							name, "string", type(eventName))
					end

					for _, func in pairs(events[eventName]) do
						func(...)
					end
				end,

				["Register"] = function(self, eventName)
					if (type(self) ~= "table") then
						eventName = self
					end

					if (type(eventName) ~= "string") then
						return RDM:Log("High", true, "The first argument of Connect has to be a string.",
							name, "string", type(eventName))
					end

					return generate(baseClass, RDM, name, eventName)
				end
			}
		)
	end,

	["Prerequisites"] = { }
}