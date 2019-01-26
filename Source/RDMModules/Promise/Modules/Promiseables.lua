return {
	["Init"] = function(baseClass, prereqs, RDM)
		-- [[ Constants ]] --

		local package = require(script.Parent.Parent.Package)
		local name = package["Name"]

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["GeneratePromiseables"] = function(self)
					local gotPromiseables = { }
					local gotCatches = { }
					local continuePromise = true
					local gotAfter = nil

					local promiseables = {
						["after"] = function(promSelf, func)
							if (type(func) ~= "function") then
								return RDM:Log("High", true, "Wrong first argument for after",
									name, "function", type(func))
							end

							gotPromiseables["After"] = func

							local function run(resolve, reject)
								repeat wait() until gotAfter ~= nil or continuePromise == false

								if (continuePromise) then
									resolve(gotAfter)
								end

								return true
							end

							local promiseables, resolve, reject = self:GeneratePromiseables()

							coroutine.resume(coroutine.create(run), resolve, reject)

							return promiseables
						end,

						["finally"] = function(promSelf, func)
							if (type(func) ~= "function") then
								return RDM:Log("High", true, "Wrong first argument for finally",
									name, "function", type(func))
							end

							gotPromiseables["Finally"] = func

							continuePromise = false

							return true
						end,

						["catch"] = function(promSelf, message, func)
							if (type(promSelf) ~= "table") then
								return RDM:Log("High", true, "Call catch with a : instead of a .",
									name, ":", ".")
							end

							if (type(message) == "function") then
								func, message = message, nil
							end

							if (message ~= nil and type(message) ~= "string") then
								return RDM:Log("High", true, "Wrong first argument for catch",
									name, "string", type(message))
							end

							if (type(func) ~= "function") then
								return RDM:Log("High", true, "Wrong second argument for catch",
									name, "function", type(func))
							end

							if (message ~= nil) then
								gotCatches[message] = func
							else
								table.insert(gotCatches, func)
							end

							return {
								["catch"] = promSelf["catch"],

								["complete"] = promSelf["complete"]
							}
						end,

						["complete"] = function(promSelf)
							continuePromise = false

							return true
						end,
					}

					local function resolve(...)
						gotAfter = gotPromiseables["After"](...)

						if (gotPromiseables["Finally"]) then
							gotPromiseables["Finally"](...)
						end

						return true
					end

					local function reject(...)
						if (gotPromiseables["Catch"] == nil) then
							return RDM:Log("High", true, "Unhandled reject for the promise.",
								name, ".catch()", "nil")
						end

						if (gotCatches[({ ... })[1]] ~= nil) then
							local send = { }

							for ind, data in pairs({ ... }) do
								if (ind > 1) then
									send[ind] = data
								end
							end

							gotCatches[({ ... })[1]](unpack(send))
						else
							gotCatches[1](...)
						end

						if (gotPromiseables["Finally"]) then
							gotPromiseables["Finally"](...)
						end

						return true
					end

					return promiseables, resolve, reject
				end,
			} -- todo more stuff
		)
	end,

	["Prerequisites"] = { }
}