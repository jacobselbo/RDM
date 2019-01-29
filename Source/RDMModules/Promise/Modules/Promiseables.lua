return {
	["Init"] = function(baseClass, prereqs, RDM)
		-- [[ Constants ]] --

		local package = require(script.Parent.Parent.Package)
		local name = package["Name"]

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["GeneratePromiseables"] = function(self, want)
					local gotPromiseables = { }
					local gotCatches = { }

					local continuePromise = true

					local gotAfter = nil
					local gotReject = nil

					local promiseables = baseClass:Extend({
						["Name"] = "Promiseables",

						["after"] = function(promSelf, func)
							if (type(func) ~= "function") then
								return RDM:Log("High", true, "Wrong first argument for after",
									name, "function", type(func))
							end

							gotPromiseables["After"] = func

							local function run(resolve, reject)
								repeat wait() until gotAfter ~= nil or continuePromise == false or gotReject ~= nil

								if (continuePromise) then
									resolve(gotAfter)
								end

								if (gotReject ~= nil) then
									reject(unpack(gotReject))
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
						end,

						["catch"] = function(promSelf, message, func)
							if (type(promSelf) ~= "table") then
								message, func = promSelf, message
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

							local promiseables = self:GeneratePromiseables(true)

							return {
								["catch"] = promiseables["catch"],

								["complete"] = promiseables["complete"]
							}
						end,

						["complete"] = function(promSelf)
							continuePromise = false
						end,
					})

					local function resolve(...)
						if (gotPromiseables["After"]) then
							gotAfter = gotPromiseables["After"](...)
						end

						if (gotPromiseables["Finally"]) then
							gotPromiseables["Finally"](...)
						end

						return true
					end

					local function reject(...)
						local allTable = { ... }

						gotReject = allTable

						if (gotCatches[allTable[1]] ~= nil) then
							local send = { }

							for ind, data in pairs(allTable) do
								if (ind > 1) then
									send[ind] = data
								end
							end

							gotCatches[allTable[1]](unpack(send))
						else
							if (gotCatches[1]) then
								gotCatches[1](...)
							elseif (gotPromiseables["Finally"] == nil) then
								return RDM:Log("High", true, "Unhandled reject for the promise. : " .. unpack({ ... }),
									name, ".catch()", "nil")
							end
						end

						if (gotPromiseables["Finally"]) then
							gotPromiseables["Finally"](...)
						end

						return true
					end

					if (want == nil or want == false) then
						return promiseables, resolve, reject
					else
						return promiseables
					end
				end,
			} -- todo more stuff
		)
	end,

	["Prerequisites"] = { }
}