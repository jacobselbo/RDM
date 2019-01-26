return {
	["Init"] = function(baseClass, prereqs, RDM)
		-- [[ Constants ]] --

		local splitFormat = "([^%s]+)"
		local html = prereqs["Html"]

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Starts"] = function(self, str, start)
					if (type(self) ~= "table") then
						str, start = self, str
					end

					if (type(str) ~= "string" or type(start) ~= "string") then
						return error("Invalid string or start given. Given - " ..
							type(str) .. "/" .. type(start) .. " Excepted - string/string")
					end

					if (str == "" or start == "") then
						return error("Invalid string or start given. Given - " ..
							str .. "/" .. start .. " Excepted - $test/$")
					end

					return string.sub(str, 1, string.len(start)) == start
				end,

				["Ends"] = function(self, str, ends)
					if (type(self) ~= "table") then
						str, ends = self, str
					end

					if (type(str) ~= "string" or type(ends) ~= "string") then
						return error("Invalid string or ends given. Given - " ..
							type(str) .. "/" .. type(ends) .. " Excepted - string/string")
					end

					if (str == "") then
						return error("Invalid string or ends given. Given - " .. str .. " Excepted - test$")
					end

					return ends == "" or string.sub(str, - string.len(ends)) == ends
				end,

				["Trim"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excepted - string")
					end

					return string.gsub(str, "^%s*(.-)%s*$", "%1")
				end,

				["Join"] = function(self, fields, join)
					if (self["Trim"] == nil) then
						fields, join = self, fields
					end

					if (type(fields) ~= "table" or type(join) ~= "string") then
						return error("Invalid fields or join given. Given - " ..
							type(fields) .. "/" .. type(join) .. " Excepted - table/string")
					end

					if (#fields == 0) then
						return error("No strings in fields.")
					end

					local realJoin, finalString = join or ", ", ""

					for index, char in pairs(fields) do
						local joinN = realJoin

						if (index == #fields) then joinN = "" end

						finalString = finalString .. char .. joinN
					end

					return finalString
				end,

				["Split"] = function(self, str, sep)
					if (type(self) ~= "table") then
						return error("Use : to call Join instead of .")
					end

					local realSeperator = sep or ":"

					if (type(str) ~= "string" or type(realSeperator) ~= "string") then
						return error("Invalid string or seperator given. Given - " ..
							type(str) .. "/" .. type(realSeperator) .. " Excepted - string/string")
					end

					local pattern, fields = string.format(splitFormat, realSeperator), {
						["Join"] = self["Join"] -- Todo add more functions
					}

					str:gsub(pattern, function(c)
						fields[#fields + 1] = c
					end)

					return setmetatable(fields, {
						__newindex = function()
							return error("New indexes are locked.")
						end,

						__metatable = "Locked."
					})
				end,

				["Count"] = function(self, str, substring)
					if (type(self) ~= "table") then
						str, substring = self, str
					end

					if (type(str) ~= "string" or type(substring) ~= "string") then
						return error("Invalid string or substring given. Given - " ..
							type(str) .. "/" .. type(substring) .. " Excepted - string/string")
					end

					if (str == "" or substring == "") then
						return error("Empty string or substring given. Excpected - hellohellohello/hello")
					end

					local pattern, totalCount = substring .. "+", 0


					str:gsub(pattern, function(c)
						totalCount = totalCount + 1
					end)

					return totalCount
				end,

				["IsLower"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excepted - string")
					end

					return string.lower(str) == str
				end,

				["IsUpper"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excepted - string")
					end

					return string.upper(str) == str
				end,

				["EncodeHTML"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excepted - string")
					end

					return html:Encode(str)
				end,

				["DecodeHTMLEntities"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excepted - string")
					end

					return html:Decode(str)
				end,

				["DecodeURL"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excpected - string")
					end

					return str:gsub("%%(%x%x)", function(x)
						return string.char(tonumber(x, 16))
					end)
				end,

				["ToBoolean"] = function(self, str)
					if (type(self) ~= "table") then
						str = self
					end

					if (type(str) ~= "string") then
						return error("Invalid string given. Given - " .. type(str) .. " Excepted - string")
					end

					local lowerStr = string.lower(str)

					return 	lowerStr == 'true' or
							lowerStr == 'on' or
							lowerStr == 1 or
							lowerStr == '1' or
							lowerStr == 'yes' or
							lowerStr == true
				end
			} -- todo more stuff
		)
	end,

	["Prerequisites"] = { "Html" }
}