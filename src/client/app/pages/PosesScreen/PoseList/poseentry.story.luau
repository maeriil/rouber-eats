local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local pose_entry = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseList.pose_entry)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)

local mount = vide.mount
local px = use_px.px

local function story()
	return frame {
		color = Color3.fromRGB(0, 150, 200),
		vlayout {
			pad = padding_types.px16,
		},
		pane {
			size = function()
				return UDim2.new(0, px(750), 0, px(64))
			end,
			pose_entry {
				active = function()
					return false
				end,
				blur = function()
					return false
				end,
				pose = function()
					local pose: types.rouber_pose_t = "default_deliver_pose"
					return pose
				end,
			},
		},
		pane {
			size = function()
				return UDim2.new(0, px(750), 0, px(64))
			end,
			pose_entry {
				active = function()
					return true
				end,
				blur = function()
					return false
				end,
				pose = function()
					local pose: types.rouber_pose_t = "default_deliver_pose"
					return pose
				end,
			},
		},
		pane {
			size = function()
				return UDim2.new(0, px(750), 0, px(64))
			end,
			pose_entry {
				active = function()
					return false
				end,
				blur = function()
					return true
				end,
				pose = function()
					local pose: types.rouber_pose_t = "default_deliver_pose"
					return pose
				end,
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
