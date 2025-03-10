local ReplicatedStorage = game:GetService("ReplicatedStorage")
local accept_order_page =
	require(ReplicatedStorage.client.app.features.Phone.pages.accept_order_page)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local phone_app = require(script.Parent.phone_app)
local resting_page = require(ReplicatedStorage.client.app.features.Phone.pages.resting_page)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local use_px_util = use_px
local use_px = use_px.use_px
local px = use_px_util.px
local phone = phone_app

local function story()
	use_px()

	return frame {
		size = UDim2.fromScale(1, 1),
		phone {
			resting_page {
				accept = function()
					print("accepted")
				end,
				reject = function() end,
			},
			exit = function()
				print("exit called")
			end,
			-- accept_order_page {},
		},
	}
end

return function(target)
	return mount(story, target)
end
