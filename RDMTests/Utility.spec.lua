return function()
	local classHandler = require(script.Parent.Parent.Source.ClassHandler)

	local tableUtil = classHandler:Get("Table")

	describe("Table Tests", function()
		it("{ 'hello' = 1, 'my' = 2 } should contain the value 1", function()
			local tab = {
				["hello"] = 1,
				["my"] = 2
			}

			local boolean = tableUtil:ContainsValue(tab, 1)

			expect(boolean).to.equal(true)
		end)

		it("{ 'hello' = { 'hi' = 1 }, 'my' = 2 } should the be the same table when cloned", function()
			local tab = { ["hello"] = {
								["hi"] = 1
							},
							["my"] = 2
						}

			local clone = tableUtil:Clone(tab)

			local boolean = (clone["hello"]["hi"] == 1 and clone["my"] == 2)

			expect(boolean).to.equal(true)
		end)

		it("A randomized output from { 1, 3, 5, 7 } should still be something from that table ( Uses contains value )", function()
			local tab = { 1, 3, 5, 7 }

			local random = tableUtil:Choice(tab)

			local boolean = tableUtil:ContainsValue(tab, random)

			expect(boolean).to.equal(true)
		end)
	end)
end