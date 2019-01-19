return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local cacheHandler = prereqs["CacheHandler"]
		local getHandler = prereqs["GetHandler"]

		local errorFormat =  "RDM : %s | Got - %s | Excepted - %s"

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Error"] = function(self, ...)
					return error(string.format(errorFormat, unpack({ ... })))
				end,

				-- [[ Load ]] --

				["Load"] = function(self, moduleStr, version, RDM)

					if (cacheHandler:GetLoadedProject(moduleStr) ~= nil) then
						return cacheHandler:GetLoadedProject(moduleStr)["Module"]
					end

					local unloadedModule = getHandler:Get(moduleStr)

					if (unloadedModule == false or unloadedModule == nil) then
						return self:Error("Invalid module.", moduleStr, "string")
					end

					if (unloadedModule:FindFirstChild("MainModule") == nil) then return error("Invalid RDM module given.") end
					if (unloadedModule:FindFirstChild("Package") == nil) then return error("Invalid RDM module given.") end

					local load = {
						["Module"] = require(unloadedModule:FindFirstChild("MainModule"))(RDM),
						["Package"] = require(unloadedModule:FindFirstChild("Package"))
					}

					if (version ~= nil) then
						if (load["Package"]["CurrentVersion"] ~= version) then
							return error("The package version and the wanted version are different. Change either")
						end
					end

					cacheHandler:AddLoadedProject(load["Package"]["Name"], load)

					return load
					-- todo
				end
			}
		)
	end,

	["Prerequisites"] = { "CacheHandler", "GetHandler" }
}