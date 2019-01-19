require(script.Parent.BaseClass)

local ClassHandler = require(script.Parent.ClassHandler)

return function(scrOrFenv)
	local RDM = ClassHandler:Get("RDM")

	RDM:SetProjectArea(scrOrFenv)

	return RDM
end