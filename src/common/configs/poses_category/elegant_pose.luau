local ReplicatedStorage = game:GetService("ReplicatedStorage")
local config_types = require(ReplicatedStorage.types.config_types)

local category: config_types.rouber_poses_category_config_t = {
	name = "confident_pose",
	display_name = `Confident Pose`,
	display_image = "",
	description = "some really long description about the category that can span"
		.. "multiple lines so we would need to definitely support that"
		.. "and ensure it still looks legible and good for the UI",
	list_of_poses = {},

	positive_hint_description = "Some positive hint description here",
	negative_hint_description = "Some negative hint description here",
}

return category
