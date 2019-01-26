return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local ModuleHandler = prereqs["ModuleHandler"]
		local SettingsHandler = prereqs["SettingsHandler"]
		local ProjectHandler = prereqs["ProjectHandler"]
		local GetHandler = prereqs["GetHandler"]
		local LogHandler = prereqs["LogHandler"]

		-- [[ Class ]] --

		return baseClass:Extend(
			{
				-- [[ Log ]] --

				["Log"] = function(self, logLevel, yield, message, name, expected, got)
					if (type(self) ~= "table") then
						logLevel, yield, message, name, expected, got = self, logLevel, yield, message, name, expected
					end

					return LogHandler:Log(logLevel, yield, message, name, expected, got)
				end,

				-- [[ Imports ]] --

				["Import"] = function(self, module, version)
					if (type(self) ~= "table") then
						return LogHandler:Log("High", true, "Use : instead of .",
							":", ".")
					end

					return ModuleHandler:Load(module, version, self)["Module"]
				end,

				["TryImport"] = function(self, module, version)
					if (type(self) ~= "table") then
						return LogHandler:Log("High", true, "Use : instead of .",
							":", ".")
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
						return LogHandler:Log("High", true, "No Enviroment given",
							"getfenv(1)", fenv)
					end

					if (fenv.ClassName ~= nil) then
						projectInstance = fenv
					elseif (fenv.print == nil) then
						projectInstance = fenv.script
					else
						return LogHandler:Log("High", true, "Invalid Enviorment given",
							"getfenv(1)", fenv)
					end

					if (projectInstance.ClassName ~= "ModuleScript" and projectInstance.ClassName ~= "Script") then
						return LogHandler:Log("High", true, "Invalid script given",
							"Script", projectInstance.ClassName)
					end

					local project = projectInstance.Parent

					if (project:FindFirstChild("RDMModules") == nil or
						project:FindFirstChild("Package") == nil) then
						return LogHandler:Log("High", true, "Invalid project area given.",
							"Project wiht RDMModules and Package", project)
					end

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

	["Prerequisites"] = { "SettingsHandler", "LogHandler" }
}