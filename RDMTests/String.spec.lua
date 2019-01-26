local firstStringTesting = "max&john's factory"

return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local stringUtil = RDM:Import("String")

	describe("The string: max&john's factory", function()
		it("starts with max", function()
			local boolean = stringUtil:Starts(firstStringTesting, "max")

			expect(boolean).to.equal(true)
		end)

		it("ends with factory", function()
			local boolean = stringUtil:Ends(firstStringTesting, "factory")

			expect(boolean).to.equal(true)
		end)

		it("is all lowercase", function()
			local boolean = stringUtil:IsLower(firstStringTesting)

			expect(boolean).to.equal(true)
		end)

		it("is not uppercase", function()
			local boolean = stringUtil:IsUpper(firstStringTesting)

			expect(boolean).to.equal(false)
		end)

		it("has two a's", function()
			local countTotal = stringUtil:Count(firstStringTesting, "a")

			expect(countTotal).to.equal(2)
		end)

		it("should have two arguments if split by space", function()
			local splitTotal = #stringUtil:Split(firstStringTesting, " ")

			expect(splitTotal).to.equal(2)
		end)

		it("should be the same string when decoded", function()
			local decoded = stringUtil:DecodeHTMLEntities("max&amp;john&apos;s factory")

			expect(decoded).to.equal(firstStringTesting)
		end)

		it("should be '&#109;&#97;&#120;&#38;&#106;&#111;&#104;&#110;&#39;&#115; " ..
			"&#102;&#97;&#99;&#116;&#111;&#114;&#121;' when html encoded", function()
			local encoded = stringUtil:EncodeHTML(firstStringTesting)

			expect(encoded).to.equal("&#109;&#97;&#120;&#38;&#106;&#111;&#104;&#110;&#39;&#115; " ..
				"&#102;&#97;&#99;&#116;&#111;&#114;&#121;")
		end)
	end)

	describe("Other string checks", function()
		it("'true' should be true in toBoolean", function()
			local boolean = stringUtil:ToBoolean("true")

			expect(boolean).to.equal(true)
		end)

		it("'       test       ' should be 'test' in Trim", function()
			local trimmed = stringUtil:Trim("       test       ")

			expect(trimmed).to.equal("test")
		end)

		it("'hi my name is bob' split should be the same string joined", function()
			local joined = stringUtil:Join({ "hi", "my", "name", "is", "bob" }, " ")

			expect(joined).to.equal("hi my name is bob")
		end)
	end)
end