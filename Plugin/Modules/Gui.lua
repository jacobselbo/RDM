return {
	["Init"] = function(baseClass, prereqs)
		-- [[ Place Holders ]] --
		local dockWidget
		local toolBar

		-- [[ Tool Bar Buttons ]] --
		local testConnection
		local openWidget

		-- [[ Prerequisites ]] --
		local SettingsHandler = prereqs["SettingsHandler"]

		-- [[ Services ]] --
		local HttpService = game:GetService("HttpService")

		-- [[ Setting's data ]] --
		local name = SettingsHandler:Get("Core", "Name")

		-- [[ Constants ]] --
		local dockWidgetInformation = DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			false
		)

		-- [[ Variables ]] --

		local active = false

		-- [[ Class ]] --
		return baseClass:Extend(
			{
				["Setup"] = function(self)
					toolBar = plugin:CreateToolbar(name)

					testConnection = toolBar:CreateButton("Test Connection", "Tests the HTTP connection to the RDM library website.")
					openWidget = toolBar:CreateButton("Widget", "Open and closes the widget")

					dockWidget = CreateDockWidgetPluginGui(name, dockWidgetInformation)
					dockWidget.Title = name

					self:SetupEvents()
				end,

				["SetupEvents"] = function(self)
					openWidget.Click:Connect(function()
						active = not active

						openWidget:SetActive(active)
						dockWidget.Enabled = active
					end)

					testConnection.Click:Connect(function()
						if (not HttpService.HttpEnabled) then
							return warn("HTTP hasn't been enabled yet.")
						end

						for _, websiteURL in pairs(SettingsHandler:Get("Websites")) do
							
						end
					end)
				end,

				["Load"] = function(self)
					self:Setup()


				end,
			}
		)
	end,

	["Prerequisites"] = { "SettingsHandler" }
}