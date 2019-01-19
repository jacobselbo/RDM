return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local ModuleHandler = prereqs["ModuleHandler"]
		local SettingsHandler = prereqs["SettingsHandler"]
		local ProjectHandler = prereqs["ProjectHandler"]
		local GetHandler = prereqs["GetHandler"]

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

					if (project == nil or project["ClassName"] == "Folder") then
						return GetHandler:GetLoadedDependenciesByFolder(ProjectHandler:GetProjectPath(getfenv(0)))
					end

					return GetHandler:GetLoadedDependenciesByName(project)
				end,

				["GetLoadedOptionalDependencies"] = function(self, project)
					if (type(self) ~= "table") then
						project = self
					end

					if (project == nil or project["ClassName"] == "Folder") then
						return GetHandler:GetLoadedOptionalDependenciesByFolder(ProjectHandler:GetProjectPath(getfenv(0)))
					end

					return GetHandler:GetLoadedOptionalDependenciesByName(project)
				end,

				-- [[ Setup ]] --

				["SetProjectArea"] = function(self, fenv)
					local projectInstance

					if (fenv == nil) then
						return error("Invalid arguments ginen.")
					end

					if (fenv.ClassName ~= nil) then
						projectInstance = fenv
					elseif (fenv.print == nil) then
						projectInstance = fenv.script
					else
						return error("Invalid arguments given.")
					end

					if (projectInstance.ClassName ~= "ModuleScript" and projectInstance.ClassName ~= "Script") then
						return error("Invalid script given.")
					end

					local project = projectInstance.Parent

					if (project:FindFirstChild("RDMModules") == nil or
						project:FindFirstChild("Package") == nil) then return error("Invalid project area given.") end

					SettingsHandler.Set("RDMModulesFolder", project:FindFirstChild("RDMModules"))
					SettingsHandler.Set("RDMPackageModule", project:FindFirstChild("Package"))

					ModuleHandler = prereqs["ClassHandler"]:Get("ModuleHandler")
					ProjectHandler = prereqs["ClassHandler"]:Get("ProjectHandler")
					GetHandler = prereqs["ClassHandler"]:Get("GetHandler")

					prereqs["ModuleHandler"] = ModuleHandler -- Module handler is being loaded too early so i did this
					prereqs["ProjectHandler"] = ProjectHandler
					prereqs["GetHandler"] = GetHandler

					return ProjectHandler:AddProject(project, true)
				end
			}
		)
	end,

	["Prerequisites"] = { "SettingsHandler" }
}