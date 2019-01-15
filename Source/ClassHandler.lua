local cache = {}

local class = require(script.Parent.BaseClass)

local modulesFolder = script.Parent:WaitForChild("Modules")

return class:Extend({
	["Get"] = function(self, className)
		if not cache[className] then
			local reqFile = nil

			for _, file in pairs(modulesFolder:GetDescendants()) do
				if (file.Name == className) then
					reqFile = file
				end
			end

			if (reqFile == nil) then
				error("Couldn't find module: " .. className)
			end

			if (reqFile.classname ~= "ModuleScript") then
				error("Invalid module found: " .. className)
			end

			local r = require(reqFile)
			local preReqs = {}

			if (r.Prerequisites) then
				for _, prereq in pairs(r.Prerequisites) do
					preReqs[prereq] = self:Get(prereq)
				end
			end

			preReqs["ClassHandler"] = self:Extend({ })

			cache[className] = r.Init(class:New(), preReqs)
		end

		return cache[className]
	end
})