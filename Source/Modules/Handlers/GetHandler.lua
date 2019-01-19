return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local httpService = game:GetService("HttpService")
		local insertService = game:GetService("InsertService")

		local tableUtil = prereqs["Table"]
		local settingsHandler = prereqs["SettingsHandler"]
		local cacheHandler = prereqs["CacheHandler"]

		local errorFormat =  "RDM : %s | Got - %s | Excepted - %s"
		local importFormats = {
			["Github"] = 	"github:%a+/%a+/%d%.%d%.%d",
			["ID"] = 		"id:%d+" -- Todo: Add supported file hostings
		}

		local RDMModulesFolder = settingsHandler.Get("RDMModulesFolder")
		-- local RDMPackage = settingsHandler.Get("RDMPackageModule") Todo this later
		local intergratedRDMModules = script.Parent.Parent.Parent:WaitForChild("RDMModules")

		local localModules = settingsHandler.Get("LocalModules")

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Error"] = function(self, ...)
					return error(string.format(errorFormat, unpack({ ... })))
				end,

				-- [[ Checks ]]

				["CheckHttp"] = function(self)
					if (not localModules) then
						if (not httpService.HttpEnabled) then
							error("Http hasn't been enabled for RDM. " ..
								"\nIf you want to use Local Modules add LocalModules to true in the setup. " ..
								"If not then put game:GetService('HttpService').HttpEnabled = true then play again")

							return false
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
						return error("No RDMModules folder has been added in the setup options.")
					end

					if (RDMModulesFolder:FindFirstChild(moduleStr) == nil) then
						return error("No " .. moduleStr .. " module found in RDM Modules. Make sure you have the folder in there.")
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
						return error("Invalid ID given. Got - " .. origModuleID .. " Excepted - id:12381231")
					end

					local tPS, tPM = pcall(function()
						return insertService:LoadAssetVersion(moduleID)
					end)

					if (not tPS) then
						local tMS, tMM = pcall(function()
							return insertService:LoadAsset(moduleID)
						end)

						if (not tMS) then
							return error("Invalid ID given.")
						end

						mod = tMM
					else
						mod = tPM
					end

					if (mod == nil) then
						return error("A unexcepted error has occured.")
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
					local loadedCache = cacheHandler:GetLoadedCache()
					local project = loadedCache[projectName]

					if (project == nil) then
						return error("Invalid project name given or loaded.")
					end

					local projectPackage = project["Package"]

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["Dependencies"])
				end,

				["GetLoadedOptionalDependenciesByName"] = function(self, projectName)
					local loadedCache = cacheHandler:GetLoadedCache()
					local project = loadedCache[projectName]

					if (project == nil) then
						return error("Invalid project name given or loaded. ( " .. projectName .. " )")
					end

					local projectPackage = project["Package"]

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["OptionalDependencies"])
				end,

				["GetLoadedDependenciesByFolder"] = function(self, projectFolder)
					local loadedCache = cacheHandler:GetLoadedCache()

					if (projectFolder == nil or
							projectFolder.ClassName ~= "Folder" or
							projectFolder:FindFirstChild("Package") == nil or
							projectFolder:FindFirstChild("Package").ClassName ~= "ModuleScript" or
							projectFolder:FindFirstChild("RDMModules") == nil or
							projectFolder:FindFirstChild("RDMModules").ClassName ~= "Folder") then
						return error("Invalid project given. ( " .. projectFolder.Name .. " )")
					end

					local projectPackage = require(projectFolder.Package)

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["Dependencies"])
				end,

				["GetLoadedOptionalDependenciesByFolder"] = function(self, projectFolder)
					local loadedCache = cacheHandler:GetLoadedCache()

					if (projectFolder == nil or
							projectFolder.ClassName ~= "Folder" or
							projectFolder:FindFirstChild("Package") == nil or
							projectFolder:FindFirstChild("Package").ClassName ~= "ModuleScript" or
							projectFolder:FindFirstChild("RDMModules") == nil or
							projectFolder:FindFirstChild("RDMModules").ClassName ~= "Folder") then
						return error("Invalid project given. ( " .. projectFolder.Name .. " )")
					end

					local projectPackage = require(projectFolder.Package)

					return self:GetLoadedDependenciesByTable(loadedCache, projectPackage["OptionalDependencies"])
				end,

				-- [[ Get Standard ]]

				["Get"] = function(self, moduleStr)
					if (cacheHandler:GetUnloadedProject(moduleStr) ~= nil) then
						return cacheHandler:GetUnloadedProject(moduleStr)
					end

					if (type(moduleStr) ~= "string") then
						return self:Error("Invalid module given.", type(moduleStr), "string")
					end

					local success, hostType = self:GetType(moduleStr)

					if (not success) then
						local module = self:GetByFile(moduleStr)

						cacheHandler:AddUnloadedProject(moduleStr, module)

						return module
					end

					local module = nil

					tableUtil.Switch(hostType):CaseOf({
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

					if (module.ClassName == "ModuleScript") then
						local newFolder = Instance.new("Folder")

						newFolder.Name = moduleStr
						newFolder.Parent = RDMModulesFolder

						for _, child in pairs(module:GetChildren()) do
							child.Parent = newFolder
						end

						cacheHandler:AddUnloadedProject(moduleStr, newFolder)

						return newFolder
					end

					cacheHandler:AddUnloadedProject(moduleStr, module)

					return module
				end,
			}
		)
	end,

	["Prerequisites"] = { "Table", "SettingsHandler", "CacheHandler" }
}