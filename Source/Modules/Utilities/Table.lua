return {
	["Init"] = function(baseClass, prereqs)
		return baseClass:Extend(
			{
				["Switch"] = function(self, c)
					local swtbl = {
						caseVariable = c,
						caseOf = function (self, code)
							local f

							if (self.caseVariable) then
								f = code[self.caseVariable] or code.Default
							else
								f = code.Missing or code.Default
							end

							if f then
								if type(f)=="function" then
									return f(self.caseVariable,self)
								else
									error("case "..tostring(self.caseVariable).." not a function")
								end
							end
						end
					}

					return swtbl
				end,

				["ContainsValue"] = function(self, tab, wantedValue)
					for _, tabValue in pairs(tab) do
						if (tabValue == wantedValue) then
							return true
						end
					end

					return false
				end,

				["Clone"] = function(self, tab)
					if type(tab) ~= "table" then return tab end

				    local meta = getmetatable(tab)
				    local target = { }

				    for k, v in pairs(tab) do
				        if type(v) == "table" then
				            target[k] = self:Clone(v)
				        else
				            target[k] = v
				        end
				    end

				    setmetatable(target, meta)

				    return target
				end,

				["Choice"] = function(self, tab)
					return tab[ math.random(#tab) ]
				end
			}
		)
	end,

	["Prerequisites"] = {}
}