-- stylua: ignore start
local ReplicatedStorage     = game:GetService("ReplicatedStorage")

local pane                  = require(ReplicatedStorage.client.app.components.pane.pane)
local active_conditions_hud = require(ReplicatedStorage.client.app.features.Huds.active_conditions_hud)
local use_px                = require(ReplicatedStorage.client.app.utility.use_px)
local vide                  = require(ReplicatedStorage.pkg.vide)

local mount                 = vide.mount
local px                    = use_px.px
local source                = vide.source
-- stylua: ignore end

local function story()
	local conditions = source {
		`Delivery Shakira's order before the food cools down!~`,
		`Ride the bus at least once!~`,
		`Collect all the coins before you drop off the order!~`,
	}

	use_px.use_px()
	return pane {
		size = function()
			return UDim2.new(0, px(450), 0.7, 0)
		end,
		pos = UDim2.new(1, -px(16), 0.5, 0),
		anchor = Vector2.new(1, 0.5),
		active_conditions_hud {
			conditions_list = conditions,
		},
	}
end

return function(target)
	return mount(story, target)
end
