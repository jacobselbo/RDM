return {
	["Init"] = function(baseClass, prereqs, RDM)
		-- [[ Constants ]] --

		local Promiseables = prereqs["Promiseables"]

		local package = require(script.Parent.Parent.Package)
		local name = package["Name"]

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["New"] = function(self, run)
					if (type(self) ~= "table") then
						run = self
					end

					if (type(run) ~= "function") then
						return RDM:Log("High", true, "The first argument of Generate has to be a function.",
							name, "function", type(run))
					end

					local promiseables, resolve, reject = Promiseables:GeneratePromiseables()

					coroutine.resume(coroutine.create(run), resolve, reject)

					return promiseables
				end
			} -- todo more stuff
		)
	end,

	["Prerequisites"] = { "Promiseables" }
}