return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local GetHandler = prereqs["GetHandler"]
		local CacheHandler = prereqs["CacheHandler"]
		local SettingsHandler = prereqs["SettingsHandler"]
		local LogHandler = prereqs["LogHandler"]

		local runWithErrors = SettingsHandler.Get("RunWithErrors")

		-- [[ Class ]] --

		return baseClass:Extend(
			{
				-- [[ Checks ]] --

				["CheckIfValidPackage"] = function(self, package, modules)
					local depends, optDepends = package["Dependencies"], package["OptionalDependencies"]

					local function checkValidProject(gDepend, version)
						if (self:CheckIfValidProject(gDepend, true)) then -- Can stack overflow but shouldn't happen
							local gPackage = require(gDepend.Package)

							if (gPackage["CurrentVersion"] ~= version) then
								return not LogHandler:Log("Medium", runWithErrors,
									gPackage["Name"] .. "'s version is not the same as " .. version,
									"1.3.2 : 1.3.2", gPackage["CurrentVersion"] .. " : " .. version)
							end
						else
							return false
						end

						return true
					end

					for depend, version in pairs(depends) do
						local gDepend = GetHandler:GetByFile(depend)

						if (gDepend == nil) then
							return not LogHandler:Log("High", runWithErrors,
								"Couldn't find the RDM Module",
								"String", depend)
						end

						if (not checkValidProject(gDepend, version)) then
							return false
						end
					end

					for depend, version in pairs(optDepends) do
						local gDepend = GetHandler:GetByFile(depend)

						if (gDepend) then
							if (not checkValidProject(gDepend, version)) then
								return false
							end
						end
					end

					return true
				end,

				["CheckIfValidProject"] = function(self, projectPath, rdmModule)
					if (rdmModule == nil) then
						rdmModule = false
					end

					local package, modules = projectPath:FindFirstChild("Package"),
												projectPath:FindFirstChild("RDMModules")

					local function invalidPath()
						return not LogHandler:Log("High", runWithErrors,
							"Invalid Project",
							"String", projectPath.Name)
					end

					if (package == nil) then
						return invalidPath()
					end

					if (rdmModule == false) then
						if (modules == nil) then
							return invalidPath()
						end

						if (modules.ClassName ~= "Folder") then
							return invalidPath()
						end
					end

					if (package.ClassName ~= "ModuleScript") then
						return invalidPath()
					end

					local requiredPackage = require(package)

					return self:CheckIfValidPackage(requiredPackage, modules)
				end,

				-- [[ Projects ]]

				["GetProjectPath"] = function(self, fenv, check)
					local projectFolder = fenv.script.Parent

					if (check) then
						if(not self:CheckIfValidProject(projectFolder)) then
							return false
						end

						local package = require(projectFolder:FindFirstChild("Package"))

						CacheHandler:AddCheckedProject(package["Name"], projectFolder)
					end

					return projectFolder
				end,

				["AddProject"] = function(self, projectFolder, check)
					if (check) then
						if (not self:CheckIfValidProject(projectFolder)) then
							return false
						end
					end

					local packageFile = projectFolder:FindFirstChild("Package")

					if (packageFile) then
						local package = require(packageFile)

						CacheHandler:AddCheckedProject(package["Name"], projectFolder)
					end

					return true
				end
			}
		)
	end,

	["Prerequisites"] = { "GetHandler", "CacheHandler", "SettingsHandler", "LogHandler" }
}