return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local testModule = RDM:Import("TestModule")

	describe("TestModule", function()
		it("should give true for Test", function()
			local test = testModule:Test()

			expect(test).to.equal(true)
		end)
	end)
end