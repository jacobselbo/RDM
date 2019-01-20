return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local unloadedCache = 		{ }
		local loadedCache =			{ }
		local checkedProjectCache = { }

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				-- [[ Gets ]] --

				["GetUnloadedCache"] = function(self)
					return unloadedCache
				end,

				["GetLoadedCache"] = function(self)
					return loadedCache
				end,

				["GetCheckedProjectCache"] = function(self)
					return checkedProjectCache
				end,

				["GetUnloadedProject"] = function(self, name)
					return unloadedCache[name]
				end,

				["GetLoadedProject"] = function(self, name)
					return loadedCache[name]
				end,

				["GetCheckedProject"] = function(self, name)
					return checkedProjectCache[name]
				end,

				-- [[ Sets ]]

				["AddUnloadedProject"] = function(self, name, path)
					unloadedCache[name] = path

					return true
				end,

				["AddLoadedProject"] = function(self, name, data)
					loadedCache[name] = data

					return true
				end,

				["AddCheckedProject"] = function(self, name, data)
					checkedProjectCache[name] = data

					return true
				end
			}
		)
	end,

	["Prerequisites"] = { }
}