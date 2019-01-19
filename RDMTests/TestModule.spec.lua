return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local testModule = RDM:Import("TestModule")

	describe("TestModule", function()
		it("should be alive", function()
			local test = testModule:Test()

			expect(test).to.equal(true)
		end)
	end)
end