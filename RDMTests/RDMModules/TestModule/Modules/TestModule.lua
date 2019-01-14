return {
	["Init"] = function(baseClass, prereqs, RDM)
		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Test"] = function(self)
					return true
				end	
			}  -- todo test dependencies
		)
	end,

	["Prerequisites"] = { }
}