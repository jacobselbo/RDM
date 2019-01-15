return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local httpService = game:GetService("HttpService")
		local insertService = game:GetService("InsertService")

		local tableUtil = prereqs["Table"]
		local settingsHandler = prereqs["SettingsHandler"]

		local unloadedCache = { }
		local loadedCache = { }

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

				["GetType"] = function(self, module)
					for hostType, str in pairs(importFormats) do
						if (string.find(module, str)) then
							return true, hostType
						end
					end

					return false
				end,

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
					local mod = nil

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

				["Get"] = function(self, moduleStr)
					if (unloadedCache[moduleStr] ~= nil) then return unloadedCache[moduleStr] end

					if (type(moduleStr) ~= "string") then
						return self:Error("Invalid module given.", type(moduleStr), "string")
					end

					local success, hostType = self:GetType(moduleStr)

					if (not success) then
						local module = self:GetByFile(moduleStr)

						unloadedCache[moduleStr] = module

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

					unloadedCache[moduleStr] = module

					return module
				end,

				-- [[ Load ]] --

				["Load"] = function(self, moduleStr, version, RDM)
					if (loadedCache[moduleStr] ~= nil) then return loadedCache[moduleStr]["Module"] end

					local unloadedModule = self:Get(moduleStr)

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

					if (unloadedModule.ClassName == "ModuleScript") then
						local newFolder = Instance.new("Folder")

						newFolder.Name = load["Package"]["Name"]
						newFolder.Parent = RDMModulesFolder

						for _, child in pairs(unloadedModule:GetChildren()) do
							child.Parent = newFolder
						end

						unloadedCache[load["Package"]["Name"]] = newFolder
					end

					loadedCache[load["Package"]["Name"]] = load

					return load
					-- todo
				end,

				-- [[ Dependencies ]] --

				["GetLoadedDependencies"]  = function(self, projectName)
					local project = loadedCache[projectName]

					if (project == nil) then
						return error("Invalid project name given or loaded.")
					end

					local projectPackage = project["Package"]

					local loadedDependencies = { }
					local wantedDependencies = projectPackage["Dependencies"]

					for name, data in pairs(loadedCache) do
						if (wantedDependencies[name] ~= nil) then
							loadedDependencies[name] = data
						end
					end

					return loadedDependencies
				end,

				["GetLoadedOptionalDependencies"] = function(self, projectName)
					local project = loadedCache[projectName]

					if (project == nil) then
						return error("Invalid project name given or loaded.")
					end

					local projectPackage = project["Package"]

					local loadedDependencies = { }
					local wantedDependencies = projectPackage["OptionalDependencies"]

					for name, data in pairs(loadedCache) do
						if (wantedDependencies[name] ~= nil) then
							loadedDependencies[name] = data
						end
					end

					return loadedDependencies
				end
			}
		)
	end,

	["Prerequisites"] = { "Table", "SettingsHandler" }
}