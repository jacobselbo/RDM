return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local HttpService = game:GetService("HttpService")
		local InsertService = game:GetService("InsertService")

		local Table = prereqs["Table"]
		local SettingsHandler = prereqs["SettingsHandler"]
		local CacheHandler = prereqs["CacheHandler"]
		local LogHandler = prereqs["LogHandler"]

		local importFormats = {
			["Github"] = 	"github:%a+/%a+/%d%.%d%.%d",
			["ID"] = 		"id:%d+" -- Todo: Add supported file hostings
		}

		local RDMModulesFolder = SettingsHandler.Get("RDMModulesFolder")
		local runWithErrors = SettingsHandler.Get("RunWithErrors")
		local localModules = SettingsHandler.Get("LocalModules")
		-- local RDMPackage = SettingsHandler.Get("RDMPackageModule") Todo this later

		local intergratedRDMModules = script.Parent.Parent.Parent:WaitForChild("RDMModules")

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				-- [[ Checks ]] --

				["CheckHttp"] = function(self)
					if (not localModules) then
						if (not HttpService.HttpEnabled) then
							return not LogHandler:Log("High", true, "Http hasn't been enabled for RDM. " ..
								"\nIf you want to use Local Modules add LocalModules to true in the setup. " ..
								"If not then put game:GetService('HttpService').HttpEnabled = true then play again",
								"HTTP Enabled", "HTTP Disabled")
						else
							return true
						end
					else
						return false
					end
				end,

				-- [[ Gets ]] --

				["GetType"] = function(self, module)
					for hostType, str in pairs(importFormats) do
						if (string.find(module, str)) then
							return true, hostType
						end
					end

					return false
				end,

				["GetByGithub"] = function(self, moduleStr)
					--[[ if (self:CheckHttp()) then

					end

					TODO ]]
				end,

				["GetByFile"] = function(self, moduleStr)
					if (intergratedRDMModules:FindFirstChild(moduleStr) ~= nil) then
						return intergratedRDMModules[moduleStr]
					end

					if (RDMModulesFolder == false) then
						return not LogHandler:Log("High", true,
							"No RDMModules folder has been added in the setup options.",
							"RDMModules folder in setup options",
							"N/A")
					end

					if (RDMModulesFolder:FindFirstChild(moduleStr) == nil) then
						return not LogHandler:Log("High", runWithErrors,
							"No " .. moduleStr .. " module found in RDM Modules. " ..
							"Make sure you have the folder in there.",
							moduleStr .. " in RDM Modules", moduleStr)
					end

					return RDMModulesFolder:FindFirstChild(moduleStr)
				end,

				["GetByID"] = function(self, moduleID)
					local origModuleID = moduleID
					local mod

					if (type(moduleID) == "string") then
						moduleID = string.sub(moduleID, 4)

						moduleID = tonumber(moduleID)
					end

					if (moduleID == nil) then
						return not LogHandler:Log("High", runWithErrors, "Invalid ID given.",
							"12837123", origModuleID)
					end

					local tPS, tPM = pcall(function()
						return InsertService:LoadAssetVersion(moduleID)
					end)

					if (not tPS) then
						local tMS, tMM = pcall(function()
							return InsertService:LoadAsset(moduleID)
						end)

						if (not tMS) then
							return not LogHandler:Log("High", runWithErrors, "Invalid ID given.",
								"12837123", moduleID)
						end

						mod = tMM
					else
						mod = tPM
					end

					if (mod == nil) then
						return LogHandler:Log("High", runWithErrors, "Invalid ID given.",
							"12837123", moduleID)
					end

					mod.Parent = RDMModulesFolder

					return mod
				end,

				-- [[ Internal Grab Dependencies ]]

				["GetLoadedDependenciesByTable"] = function(self, loadedCache, wantedDependencies)
					local loadedDependencies = { }

					for name, data in pairs(loadedCache) do
						if (wantedDependencies[name] ~= nil) then
							loadedDependencies[name] = data
						end
					end

					return loadedDependencies
				end,

				-- [[ Dependencies ]] --

				["GetLoadedDependenciesByName"] = function(self, projectName)
					local loadedCache = CacheHandler:GetLoadedCache()
					local project = loadedCache[projectName]

					if (project == nil) then
						return not LogHandler:Log("High", true, "Invalid project name given or loaded.",
							"String", projectName)
					end

					local projectPackage = project["Package"]

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["Dependencies"])
				end,

				["GetLoadedOptionalDependenciesByName"] = function(self, projectName)
					local loadedCache = CacheHandler:GetLoadedCache()
					local project = loadedCache[projectName]

					if (project == nil) then
						return not LogHandler:Log("High", true, "Invalid project name given or loaded.",
							"String", projectName)
					end

					local projectPackage = project["Package"]

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["OptionalDependencies"])
				end,

				["GetLoadedDependenciesByFolder"] = function(self, projectFolder)
					local loadedCache = CacheHandler:GetLoadedCache()

					if (projectFolder == nil or
							projectFolder.ClassName ~= "Folder" or
							projectFolder:FindFirstChild("Package") == nil or
							projectFolder:FindFirstChild("Package").ClassName ~= "ModuleScript" or
							projectFolder:FindFirstChild("RDMModules") == nil or
							projectFolder:FindFirstChild("RDMModules").ClassName ~= "Folder") then
						return not LogHandler:Log("High", true, "Invalid project name given or loaded.",
							"String", projectFolder.Name)
					end

					local projectPackage = require(projectFolder.Package)

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["Dependencies"])
				end,

				["GetLoadedOptionalDependenciesByFolder"] = function(self, projectFolder)
					local loadedCache = CacheHandler:GetLoadedCache()

					if (projectFolder == nil or
							projectFolder.ClassName ~= "Folder" or
							projectFolder:FindFirstChild("Package") == nil or
							projectFolder:FindFirstChild("Package").ClassName ~= "ModuleScript" or
							projectFolder:FindFirstChild("RDMModules") == nil or
							projectFolder:FindFirstChild("RDMModules").ClassName ~= "Folder") then
						return not LogHandler:Log("High", true, "Invalid project name given or loaded.",
							"String", projectFolder.Name)
					end

					local projectPackage = require(projectFolder.Package)

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["OptionalDependencies"])
				end,

				-- [[ Get Standard ]]

				["Get"] = function(self, moduleStr)
					if (CacheHandler:GetUnloadedProject(moduleStr) ~= nil) then
						return CacheHandler:GetUnloadedProject(moduleStr)
					end

					if (type(moduleStr) ~= "string") then
						return not LogHandler:Log("High", true, "Wrong type of module given.",
							"String", type(moduleStr))
					end

					local success, hostType = self:GetType(moduleStr)

					if (not success) then
						local module = self:GetByFile(moduleStr)

						CacheHandler:AddUnloadedProject(moduleStr, module)

						return module
					end

					local module = nil

					Table:Switch(hostType):caseOf({
						["Github"] = function()
							module = self:GetByGithub(moduleStr)
						end,

						["ID"] = function()
							module = self:GetByID(moduleStr)
						end
					})

					repeat
						wait() -- todo timeout
					until module ~= nil

					if (SettingsHandler.Get("DebugPrint")) then
						LogHandler:Log("Debug", false, "Adding " .. moduleStr .. " to the Unloaded Module Cache")
					end

					if (module.ClassName == "ModuleScript") then
						local newFolder = Instance.new("Folder")

						newFolder.Name = moduleStr
						newFolder.Parent = RDMModulesFolder

						for _, child in pairs(module:GetChildren()) do
							child.Parent = newFolder
						end

						CacheHandler:AddUnloadedProject(moduleStr, newFolder)

						return newFolder
					end

					CacheHandler:AddUnloadedProject(moduleStr, module)

					return module
				end,
			}
		)
	end,

	["Prerequisites"] = { "Table", "SettingsHandler", "CacheHandler", "LogHandler" }
}