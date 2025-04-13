-- stylua: ignore start
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local HudScreen          = require(script.Parent.HudScreen)
local Mock_Delivery_list = require(ReplicatedStorage.client.app.pages.RouberScreen._MOCKS.Mock_Delivery_list)
local PhoneScreen        = require(script.Parent.PhoneScreen)
local RouberScreen       = require(script.Parent.RouberScreen)
local change_page        = require(ReplicatedStorage.client.app.utility.change_page)
local frame              = require(ReplicatedStorage.client.app.components.pane.frame)
local PosesScreen        = require(ReplicatedStorage.client.app.pages.PosesScreen)
local types              = require(ReplicatedStorage.types)
local uistore            = require(ReplicatedStorage.client.app.uistore)
local use_px             = require(ReplicatedStorage.client.app.utility.use_px)
local vide               = require(ReplicatedStorage.pkg.vide)

local mount              = vide.mount
local switch             = vide.switch
local create             = vide.create
-- stylua: ignore end

local function story()
	-- stylua: ignore start
	local order_list = uistore.DeliveryOrderList
	local page = uistore.page
  local hud    : types.GamePages = "HudScreen"
  local phone  : types.GamePages = "PhoneScreen"
  local rouber : types.GamePages = "RouberScreen"
  local poses  : types.GamePages = "pose_screen"
	-- stylua: ignore end

	use_px.use_px()
	order_list(Mock_Delivery_list :: never)
	change_page("pose_screen")

	return switch(page) {
		[""] = function()
			return frame {
				size = UDim2.new(1, 0, 1, 0),
				create "TextLabel" {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					TextSize = 96,
					Text = "Unkown page is shown",
				},
			}
		end,
		[hud] = function()
			return HudScreen {}
		end,
		[phone] = function()
			return PhoneScreen {}
		end,
		[rouber] = function()
			return RouberScreen {}
		end,
		[poses] = function()
			return PosesScreen {}
		end,
	}
end

return function(target)
	return mount(story, target)
end
