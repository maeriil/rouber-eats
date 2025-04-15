local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local result_display_pose_1 =
	require(ReplicatedStorage.client.app.features.Result.result_display_pose_1)
local result_sources = require(ReplicatedStorage.client.app.features.Result.result_sources)
local result_title = require(ReplicatedStorage.client.app.features.Result.result_title)
local vide = require(ReplicatedStorage.pkg.vide)

local show = vide.show

local function result(props)
	return frame {
		show(result_sources.start_pose1, function()
			return result_display_pose_1 {}
		end),
		show(result_sources.start_animation_title, function()
			return result_title {}
		end),
	}
end

return result
