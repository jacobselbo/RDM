return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local ModuleHandler = prereqs["ModuleHandler"]
		local SettingsHandler = prereqs["SettingsHandler"]

		local package = SettingsHandler.Get("RDMPackageModule")

		-- [[ Class ]] --

		return baseClass:Extend(
			{
				-- [[ Imports ]] --

				["Import"] = function(self, module, version)
					if (type(self) ~= "table") then
						return error("Use : instead of . on import")
					end

					return ModuleHandler:Load(module, version, self)["Module"]
				end,

				["TryImport"] = function(self, module, version)
					if (type(self) ~= "table") then
						return error("Use : instead of . on import")
					end

					local success, message = pcall(function()
						return ModuleHandler:Load(module, version, self)["Module"]
					end)

					if (not success) then return false end

					return message
				end,

				-- [[ Dependencies ]] --

				["GetLoadedDependencies"] = function(self, project)
					if (type(self) ~= "table") then
						project = self
					end

					return ModuleHandler:GetLoadedDependencies(project or package["Name"])
				end,

				["GetLoadedOptionalDependencies"] = function(self, project)
					if (type(self) ~= "table") then
						project = self
					end

					return ModuleHandler:GetLoadedOptionalDependencies(project or package["Name"])
				end,

				-- [[ Setup ]] --

				["SetProjectArea"] = function(self, project)
					if (project.ClassName ~= "ModuleScript" and project.ClassName ~= "Script") then return error("Invalid script given.") end

					local project = project.Parent

					if (project:FindFirstChild("RDMModules") == nil or
						project:FindFirstChild("Package") == nil) then return error("Invalid project area given.") end

					SettingsHandler.Set("RDMModulesFolder", project:FindFirstChild("RDMModules"))
					SettingsHandler.Set("RDMPackageModule", project:FindFirstChild("Package"))

					ModuleHandler = prereqs["ClassHandler"]:Get("ModuleHandler")

					prereqs["ModuleHandler"] = ModuleHandler -- Module handler is being loaded too early so i did this

					return true
				end
			}
		)
	end,

	["Prerequisites"] = { "SettingsHandler" }
}