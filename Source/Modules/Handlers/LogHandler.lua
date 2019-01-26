return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local Table = prereqs["Table"]

		local logFormat = "%s priority | %s | RDM - %s | %s"
		local errorFormat = "%s : Expected - %s : Got - %s"

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				-- [[ Low Level Logs ]] --

				["LowLog"] = function(self, logLevel, yield, message)
					Table:Switch(logLevel):caseOf({
						["High"] = function()
							if (yield) then
								error(message)
							else
								warn(message)
							end
						end,

						["Medium"] = function()
							warn(message)
						end,

						["Print"] = function()
							print(message)
						end,

						["Debug"] = function()
							print("Debug")

							print(message)
						end
					})

					return true
				end,

				-- [[ High Level Logs ]] --

				["Log"] = function(self, logLevel, yield, message, name, expected, got)
					local yieldString = "Non-yielding"
					local sendMessage

					if (yield) then
						yieldString = "Yielding"
					end

					if (not name) then
						name = "RDM"
					end

					Table:Switch(logLevel):caseOf({
						["High"] = function()
							sendMessage = string.format(logFormat, logLevel, yieldString, name,
								string.format(errorFormat, message, expected, got))
						end,

						["Default"] = function()
							sendMessage = string.format(logFormat, logLevel, yieldString, message)
						end
					})

					return self:LowLog(logLevel, yield, sendMessage)
				end,
			}
		)
	end,

	["Prerequisites"] = { "Table" }
}