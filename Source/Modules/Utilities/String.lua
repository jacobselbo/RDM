return {
	["Init"] = function(baseClass, prereqs)
		return baseClass:Extend(
			{
				["Starts"] = function(str, start)
					return string.sub(str, 1, string.len(start)) == start
				end,

				["Ends"] = function(str, strEnd)
				   return strEnd == "" or string.sub(str, -string.len(strEnd)) == strEnd
				end,

				["Trim"] = function(str)
					return str:gsub("^%s*(.-)%s*$", "%1")
				end,

				["Replace"] = function(str, a, b)
					return str:gsub(a, b)
				end,

				["Split"] = function(str, sepPossibly)
					local sep, fields = sepPossibly or ":", {}
					local pattern = string.format("([^%s]+)", sep)

					str:gsub(pattern, function(c) fields[#fields + 1] = c end)

					return fields
				end
			}
		)
	end,

	["Prerequisites"] = {}
}