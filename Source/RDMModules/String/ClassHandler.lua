local cache = {}

local class = require(script.Parent.BaseClass)

local modulesFolder = script.Parent:WaitForChild("Modules")

return class:Extend({
	["Get"] = function(self, className, RDM)
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

			if (reqFile.ClassName ~= "ModuleScript") then
				error("Invalid module found: " .. className)
			end

			local r = require(reqFile)
			local preReqs = {}

			if (r.Prerequisites) then
				for _, prereq in pairs(r.Prerequisites) do
					preReqs[prereq] = self:Get(prereq, RDM) -- This could cause a stack overflow if two classes require eachother. However, if you do it *properly*, and don't cycle it like I will at some point; you'll be fine.
				end
			end

			preReqs["ClassHandler"] = self:Extend({ })

			cache[className] = r.Init(class:New(), preReqs, RDM)
		end

		return cache[className]
	end
})