-- stylua: ignore start
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local HudScreen          = require(script.Parent.HudScreen)
local Mock_Delivery_list = require(ReplicatedStorage.client.app.pages.RouberScreen._MOCKS.Mock_Delivery_list)
local PhoneScreen        = require(script.Parent.PhoneScreen)
local RouberScreen       = require(script.Parent.RouberScreen)
local change_page        = require(ReplicatedStorage.client.app.utility.change_page)
local BackpackScreen     = require(ReplicatedStorage.client.app.pages.BackpackScreen)
local FallbackScreen     = require(ReplicatedStorage.client.app.pages.FallbackScreen)
local PosesScreen        = require(ReplicatedStorage.client.app.pages.PosesScreen)
local types              = require(ReplicatedStorage.types)
local uistore            = require(ReplicatedStorage.client.app.uistore)
local use_px             = require(ReplicatedStorage.client.app.utility.use_px)
local vide               = require(ReplicatedStorage.pkg.vide)

local mount              = vide.mount
local switch             = vide.switch
-- stylua: ignore end

local function story()
	-- stylua: ignore start
	local order_list = uistore.DeliveryOrderList
	local page = uistore.page
  local hud      : types.GamePages = "HudScreen"
  local phone    : types.GamePages = "PhoneScreen"
  local rouber   : types.GamePages = "RouberScreen"
  local poses    : types.GamePages = "pose_screen"
  local backpack : types.GamePages = "BackpackScreen"
	-- stylua: ignore end

	use_px.use_px()
	order_list(Mock_Delivery_list :: never)
	change_page("BackpackScreen")

	return switch(page) {
		[""] = function()
			return FallbackScreen {}
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
		[backpack] = function()
			return BackpackScreen {}
		end,
	}
end

return function(target)
	return mount(story, target)
end
