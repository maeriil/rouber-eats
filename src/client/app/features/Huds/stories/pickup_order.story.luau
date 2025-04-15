-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pickup_order_hud  = require(ReplicatedStorage.client.app.features.Huds.pickup_order_hud)
local vide              = require(ReplicatedStorage.pkg.vide)

local mount             = vide.mount
-- stylua: ignore end

local function story()
	return pickup_order_hud {
		details = function()
			return `shakira`
		end,
	}
end

return function(target)
	return mount(story, target)
end
