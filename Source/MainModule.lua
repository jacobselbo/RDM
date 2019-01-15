require(script.Parent.BaseClass)

local ClassHandler = require(script.Parent.ClassHandler)

return function(proj)
	local RDM = ClassHandler:Get("RDM")

	RDM:SetProjectArea(proj)

	return RDM
end