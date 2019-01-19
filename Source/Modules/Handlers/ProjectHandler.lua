return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local getHandler = prereqs["GetHandler"]
		local cacheHandler = prereqs["CacheHandler"]

		-- [[ Class ]] --

		return baseClass:Extend(
			{
				-- [[ Checks ]]

				["CheckIfValidPackage"] = function(self, package, modules)
					local depends, optDepends = package["Dependencies"], package["OptionalDependencies"]

					local function checkValidProject(gDepend, version)
						if (self:CheckIfValidProject(gDepend, true)) then -- Can stack overflow but shouldn't happen
							local gPackage = require(gDepend.Package)

							if (gPackage["CurrentVersion"] ~= version) then
								error(gPackage["Name"] .. "'s version ( " .. gPackage["CurrentVersion"] .. " ) is not the same as " .. version)

								return false
							end
						else
							return false
						end

						return true
					end

					for depend, version in pairs(depends) do
						local gDepend = getHandler:GetByFile(depend)

						if (gDepend == nil) then
							error("There isn't " .. depend .. " in the RDM Modules.")

							return false
						end

						if (not checkValidProject(gDepend, version)) then
							return false
						end
					end

					for depend, version in pairs(optDepends) do
						local gDepend = getHandler:GetByFile(depend)

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
						error("Invalid project. Called: " .. projectPath.Name)

						return false
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

						print(modules.ClassName)
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

						cacheHandler:AddCheckedProject(package["Name"], projectFolder)
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

						cacheHandler:AddCheckedProject(package["Name"], projectFolder)
					end

					return true
				end
			}
		)
	end,

	["Prerequisites"] = { "GetHandler", "CacheHandler" }
}