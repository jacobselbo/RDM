return {
	["Init"] = function(baseClass, prereqs)
		return baseClass:Extend(
			{
				["Switch"] = function(c)
					local swtbl = {
						caseVariable = c,
						caseOf = function (self, code)
							local f

							if (self.caseVariable) then
								f = code[self.caseVariable] or code.default
							else
								f = code.missing or code.default
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

				["ContainsKey"] = function(tab, key)
					for keyValue, _ in pairs(tab) do
						if keyValue == key then
							return true
						end
					end

					return false
				end,

				["ContainsValue"] = function(tab, value)
					for _, Value in pairs(tab) do
						if Value == value then
							return true
						end
					end

					return false
				end,

				["Clone"] = function(self, tab)
					if type(tab) ~= "table" then return tab end

				    local meta = getmetatable(tab)
				    local target = {}

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

				["Choice"] = function(tab)
					return tab[ math.random(#tab) ]
				end,

				["StripStatus"] = function(tab)
					tab["status"] = nil

					return tab
				end
			}
		)
	end,

	["Prerequisites"] = {}
}