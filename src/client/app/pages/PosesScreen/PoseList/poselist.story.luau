local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local PoseList = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseList)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)

local mount = vide.mount
local source = vide.source
local px = use_px.px

local function story()
	local order_poses_list = source({
		"default_deliver_pose",
		"default_deliver_pose",
		"default_deliver_pose",
		"default_deliver_pose",
	} :: types.Array<types.rouber_pose_t>) :: types.Source<types.Array<types.rouber_pose_t>>
	local active_idx = source(1)

	return frame {
		size = function()
			return UDim2.new(0.4, 0, 0.75, 0)
		end,
		pos = function()
			return UDim2.new(0, px(196), 0, 0)
		end,

		anchor = Vector2.new(0, 0),
		PoseList {
			active_idx = active_idx,
			click = active_idx,
			content = order_poses_list,
		},
	}
end

return function(target)
	return mount(story, target)
end
