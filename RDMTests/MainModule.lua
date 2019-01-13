local RDMF = game:GetService("ServerScriptService"):WaitForChild("RDM"):WaitForChild("Source")
local RDM = require(RDMF:WaitForChild("MainModule"))(script)

local stringUtil = RDM:Import("String")
local testModule = RDM:Import("TestModule")

local workedFormat = "%d Tests were ran with %d errors"

local totalTests = 0
local erroredTests = 0

local function tryAssert(v, eq, eM)
	local s, m = pcall(assert, v == eq, eM)
	
	if (not s) then 
		warn(m)
		print("	" .. v)
		
		erroredTests = erroredTests + 1
	end
	
	totalTests = totalTests + 1
end

-- [[ String Testing ]] --

tryAssert(stringUtil:Starts("$test", "$"), true, "String starts failed.")
tryAssert(stringUtil:Ends("test$", "$"), true, "String ends failed.")
tryAssert(stringUtil:Trim("     hello     "), "hello", "String trim failed.")
tryAssert(stringUtil:Join({ "hi", "my", "name", "is", "bob" }, " "), "hi my name is bob", "String join failed.")
tryAssert(#stringUtil:Split("hi-hi-hi", "-"), 3, "String split failed.")
tryAssert(stringUtil:Count("hihihihi", "hi"), 4, "String count failed.")
tryAssert(stringUtil:IsLower("hihi"), true, "String is lower failed.")
tryAssert(stringUtil:IsUpper("HIHI"), true, "String is upper failed.")
tryAssert(stringUtil:DecodeHTMLEntities("John&amp;John"), "John&John", "String escape entities failed.")
tryAssert(stringUtil:ToBoolean("on"), true, "String to boolean failed.")

-- [[ Test Local Modules ]] --

tryAssert(testModule:Test(), true, "Test module failed.")

print(string.format(workedFormat, totalTests, erroredTests))

return erroredTests == 0