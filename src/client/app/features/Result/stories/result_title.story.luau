-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local result_title      = require(ReplicatedStorage.client.app.features.Result.result_title)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)

local mount             = vide.mount
-- stylua: ignore end

local function story()
	use_px.use_px()
	return pane {
		result_title {},
	}
end

return function(target)
	return mount(story, target)
end
