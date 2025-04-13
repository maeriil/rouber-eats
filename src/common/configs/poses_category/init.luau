local ReplicatedStorage = game:GetService("ReplicatedStorage")
local config_types = require(ReplicatedStorage.types.config_types)
local types = require(ReplicatedStorage.types)
local categories =
	{} :: { [types.rouber_pose_category_t]: config_types.rouber_poses_category_config_t }

for _, module: ModuleScript in script:GetChildren() do
	local _, _content = pcall(require, module)
	local content = _content :: config_types.rouber_poses_category_config_t

	categories[content.name] = content
end

return categories
