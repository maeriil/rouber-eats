local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RouberOrderContainer = require(script.Parent.RouberOrderContainer)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local source = vide.source

local function story()
	local orders_list = source({
		["one"] = {
			clientid = -1 :: any,
			deliverytype = "some type",
			distance = -1,
			restaurant = {
				img = "",
				location = "1 Roblox Dr",
				name = "Tim Horton's",
			},
			reward = 100,
		},
		["two"] = {
			clientid = -1 :: any,
			deliverytype = "some type",
			distance = -1,
			restaurant = {
				img = "",
				location = "1 Roblox Dr",
				name = "Tim Horton's",
			},
			reward = 100,
		},
		["zzz"] = {
			clientid = -1 :: any,
			deliverytype = "some type",
			distance = -1,
			restaurant = {
				img = "",
				location = "1 Roblox Dr",
				name = "Tim Horton's",
			},
			reward = 100,
		},
	} :: { [string]: types.DeliveryOrderType })
	local active_order = source("one")

	return frame {
		size = UDim2.new(0.8, 0, 0.75, 0),
		pos = UDim2.fromScale(0.5, 0.5),
		anchor = Vector2.new(0.5, 0.5),
		RouberOrderContainer {
			orders = orders_list,
			active_order = active_order,
		},
	}
end

return function(target)
	return mount(story, target)
end
