require(script.Parent.BaseClass)

local ClassHandler = require(script.Parent.ClassHandler)

return function(RDM)
	return ClassHandler:Get("String", RDM)
end