return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local Promise = RDM:Import("Promise")

	describe("Promise", function()
		it("should be okay", function()
			expect(Promise).to.be.ok()
		end)

		it("after should take one second to fire after", function()
			Promise:New(function(resolve, reject)
				local tick1 = tick()

				wait(1)

				local tick2 = tick()

				resolve(tick2 - tick1)
			end):after(function(testTick)
				expect(testTick >= 1).to.equal(true)
			end):complete()
		end)

		it("after should allow dazy chaining", function()
			Promise:New(function(resolve, reject)
				local tick1 = tick()

				wait(1)

				local tick2 = tick()

				resolve(tick2 - tick1)
			end):after(function(testTick)
				local tick1 = tick()

				wait(1)

				local tick2 = tick()

				return (tick2 - tick1) + testTick
			end):after(function(testTick)
				expect(testTick >= 2).to.equal(true)
			end):complete()
		end)

		it("catch should catch properly", function()
			Promise:New(function(resolve, reject)
				reject("Error")
			end):catch(function(message)
				expect(message).to.equal("Error")
			end):complete()
		end)

		it("catch should allow dazy chaining", function()
			Promise:New(function(resolve, reject)
				reject("Error1")
			end):catch("Error1", function()
				expect(1).to.be.ok() -- Should be called
			end):catch("Error2", function()
				expect(nil).to.be.ok()
			end):complete()
		end)
	end)
end