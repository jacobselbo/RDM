local BaseClass = require(script.Parent.BaseClass)
local ClassHandler = require(script.Parent.ClassHandler)

return function(proj)
	local rdm = ClassHandler:Get("RDM")
	
	rdm:SetProjectArea(proj)
	
	return rdm
end