return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Constants ]] --

		local Table = prereqs["Table"]

		local logFormat = "%s priority | %s | RDM | %s"
		local errorFormat = "%s : Expected - %s : Got - %s"

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				-- [[ Low Level Logs ]] --

				["LowLog"] = function(self, logLevel, yield, message)
					print(logLevel)
					print("type logLevel " .. type(logLevel))

					Table:Switch(logLevel):caseOf({
						["High"] = function()
							print("Higha aaa")

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

				["Log"] = function(self, logLevel, yield, message, expected, got)
					local yieldString = "Non-yielding"
					local sendMessage

					if (yield) then
						yieldString = "Yielding"
					end

					Table:Switch(logLevel):caseOf({
						["High"] = function()
							print(type(logLevel), type(yield), type(message), type(expected), type(got))

							sendMessage = string.format(logFormat, logLevel, yieldString,
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