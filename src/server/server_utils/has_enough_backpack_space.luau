local ReplicatedStorage = game:GetService("ReplicatedStorage")
local backpack_list = require(ReplicatedStorage.common.configs.backpack)
local determine_space = require(script.Parent.get_item_space)

local c = require(ReplicatedStorage.common.ecs.components)
local t = require(ReplicatedStorage.types)

local function has_enough_space(
	backpack: typeof(c.Backpack.__T),
	item_to_add: { t.Entity },
	count: { number }
)
	local n = #item_to_add
	local required_space = 0

	for i = 1, n do
		required_space += determine_space(item_to_add[i], count[i])
	end

	local curr_space = 0
	--//TODO: the max space would depend on the items category. We don't have concept of categories yet
	local max_space = backpack_list[backpack.slot_kind].furnishing

	for backpack_item_id, item in backpack.items do
		--//TODO: we would need to add filter here
		curr_space += determine_space(backpack_item_id, item.count)
	end

	return curr_space + required_space <= max_space
end

return has_enough_space
