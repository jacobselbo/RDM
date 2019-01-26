return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local TestModule = RDM:Import("TestModule")

	describe("TestModule", function()
		it("should be alive", function()
			local test = TestModule:Test()

			expect(test).to.equal(true)
		end)
	end)
end