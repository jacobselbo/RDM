return function()
	local RDM = require(script.Parent.Parent.Source.MainModule)(script)
	local EventHandler = RDM:Import("EventHandler")
	local eventName = "TestEvent"
	local counter = 1

	local newEventName = function()
		counter = counter + 1

		return eventName .. counter
	end

	describe("EventHandler", function()
		it("should be alive", function()
			expect(EventHandler).to.be.ok()
		end)

		it("should create events correctly", function()
			local event = EventHandler:Register(newEventName())

			expect(event).to.be.ok()
		end)

		describe("Should handle event connecting/disconnecting/emiting properly", function()
			local gEvent

			it("should handle connects correctly", function()
				expect(function()
					EventHandler:Connect(newEventName(), function() end)
				end).never.to.throw()
			end)

			it("should handle emits correctly", function()
				local event = EventHandler:Register(newEventName())

				gEvent = event

				event:Connect(function(test)
					expect(test).to.equal(true)
				end)

				event:Emit(true)
			end)

			it("should handle disconnecting correctly", function()
				expect(function()
					gEvent:Disconnect()
				end)
			end)
		end)
	end)
end