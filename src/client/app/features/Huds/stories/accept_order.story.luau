-- stylua: ignore start
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local drop_off_order_hud = require(ReplicatedStorage.client.app.features.Huds.drop_off_order_hud)
local vide               = require(ReplicatedStorage.pkg.vide)

local mount              = vide.mount
-- stylua: ignore end

local function story()
	return drop_off_order_hud {
		details = function()
			return `shakira`
		end,
	}
end

return function(target)
	return mount(story, target)
end
