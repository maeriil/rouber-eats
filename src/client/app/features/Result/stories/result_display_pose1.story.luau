local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local result_display_pose_1 =
	require(ReplicatedStorage.client.app.features.Result.result_display_pose_1)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount

local function story()
	use_px.use_px()
	return pane {
		result_display_pose_1 {},
	}
end

return function(target)
	return mount(story, target)
end
