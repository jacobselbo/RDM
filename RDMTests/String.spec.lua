local shouldGive = "should give true for %s"
local shouldBe = "should be true for %s"

return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local stringUtil = RDM:Import("String")

	describe("String boolean checks", function()
		it(string.format(shouldGive, "Starts"), function()
			local boolean = stringUtil:Starts("$test", "$")

			except(boolean).to.equal(true)
		end)

		it(string.format(shouldGive, "Ends"), function()
			local boolean = stringUtil:Ends("test$", "$")

			except(boolean).to.equal(true)
		end)

		it(string.format(shouldGive, "IsLower"), function()
			local boolean = stringUtil:IsLower("test")

			except(boolean).to.equal(true)
		end)

		it(string.format(shouldGive, "IsUpper"), function()
			local boolean = stringUtil:IsUpper("TEST")

			except(boolean).to.eqaul(true)
		end)

		it(string.format(shouldGive, "ToBoolean"), function()
			local boolean = stringUtil:ToBoolean("true")

			except(boolean).to.equal(true)
		end)
	end)

	describe("String equals checks", function()
		it(string.format(shouldBe, "Trim"), function()
			local trimmed = stringUtil:Trim("     test     ")

			except(trimmed).to.equal("test")
		end)

		it(string.format(shouldBe, "Join"), function()
			local joined = stringUtil:Join({ "hi", "my", "name", "is", "bob" }, " ")

			except(joined).to.equal("hi my name is bob")
		end)

		it(string.format(shouldBe, "Split"), function()
			local #splitTotal = stringUtil:Split("test-test-test")

			except(splitTotal).to.equal(3)
		end)

		it(string.format(shouldBe, "Count"), function()
			local countTotal = stringUtil:Count("hihihihi")

			except(countTotal).to.equal(4)
		end)

		it(string.format(shouldBe, "DecodeHTMLEntities"), function()
			local decoded = stringUtil:DecodeHTMLEntities("John&amp;John")

			except(decoded).to.equal("John&John")
		end)
	end)
end