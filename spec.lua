-- Taken from Roact github

--[[
	Loads our library and all of its dependencies, then runs tests using TestEZ.
]]

-- If you add any dependencies, add them to this table so they'll be loaded!
local loadModules = {
	["Source"] = "Source",
	["RDMTests"] = "RDMTests"
	["TestEZ"] = "Modules/TestEZ/lib"
}

-- This makes sure we can load Lemur and other libraries that depend on init.lua
package.path = package.path .. ";?/init.lua"

-- If this fails, make sure you've cloned all Git submodules of this repo!
local lemur = require("Modules.Lemur")

-- Create a virtual Roblox tree
local habitat = lemur.Habitat.new()

-- We'll put all of our library code and dependencies here
local Root = lemur.Instance.new("Folder")
Root.Name = "Root"

-- Load all of the modules specified above
for name, path in ipairs(loadModules) do
	local container = habitat:loadFromFs(path)

	container.Name = name
	container.Parent = Root
end

-- Load TestEZ and run our tests
local TestEZ = habitat:require(Root.TestEZ)

local results = TestEZ.TestBootstrap:run(Root.RDMTests, TestEZ.Reporters.TextReporter)

-- Did something go wrong?
if (results.failureCount > 0) then
	os.exit(1)
end