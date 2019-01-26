return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local CacheHandler = prereqs["CacheHandler"]
		local GetHandler = prereqs["GetHandler"]
		local SettingsHandler = prereqs["SettingsHandler"]
		local LogHandler = prereqs["LogHandler"]

		local runWithErrors = SettingsHandler.Get("RunWithErrors")

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				-- [[ Load ]] --

				["Load"] = function(self, moduleStr, version, RDM)
					if (CacheHandler:GetLoadedProject(moduleStr) ~= nil) then
						return CacheHandler:GetLoadedProject(moduleStr)["Module"]
					end

					local unloadedModule = GetHandler:Get(moduleStr)

					if (unloadedModule == false or unloadedModule == nil) then
						return not LogHandler:Log("High", runWithErrors,
							"Invalid module given.", nil,
							"String", moduleStr)
					end

					if (unloadedModule:FindFirstChild("MainModule") == nil or
						unloadedModule:FindFirstChild("Package") == nil) then
						return not LogHandler:Log("High", runWithErrors,
							"Invalid RDM module given.", nil,
							"A package with MainModule and Package", unloadedModule)
					end

					local package = require(unloadedModule:FindFirstChild("Package"))
					local load = {
						["Module"] = require(unloadedModule:FindFirstChild("MainModule"))(RDM),
						["Package"] = package
					}

					if (version ~= nil) then
						if (package["CurrentVersion"] ~= version) then
							return LogHandler:Log("Medium", runWithErrors,
								"The package version and the wanted version are different.", nil,
								"1.3.2 : 1.3.2", package["CurrentVersion"] .. " : " .. version)
						end
					end

					if (SettingsHandler.Get("DebugPrint")) then
						LogHandler:Log("Debug", false, "Adding " .. moduleStr .. " to the Loaded Module Cache.\n" ..
							"Lisence - " .. package["Lisence"]["Type"] .. " | Version - " .. package["CurrentVersion"], nil)
					end

					CacheHandler:AddLoadedProject(load["Package"]["Name"], load)

					return load
					-- todo
				end
			}
		)
	end,

	["Prerequisites"] = { "CacheHandler", "GetHandler", "SettingsHandler", "LogHandler" }
}