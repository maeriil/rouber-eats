local ReplicatedStorage = game:GetService("ReplicatedStorage")

local order_receipt = require(ReplicatedStorage.client.app.pages.RouberScreen.pages.order_receipt)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local function story()
	use_px.use_px()

	return order_receipt {}
end

return function(target)
	return mount(story, target)
end
