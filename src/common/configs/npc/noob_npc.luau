-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cheer_emotion     = require(ReplicatedStorage.common.configs.emotes.cheer_emotion)
local config_types      = require(ReplicatedStorage.types.config_types)

local gameassets        = ReplicatedStorage.gameassets
local npc_list          = gameassets.npc
-- stylua: ignore end

local npc: config_types.rouber_npc_config_t = {
	name = "noob_one",
	display_name = "Noob I",

	house_type = "House_BasicHouse",
	house_location_id = "",

	model = npc_list.noob,

	conditions = {},
	conditions_met_rewards = {},

	preferred_pose_category = "unknown_pose",
	disliked_pose_category = "unknown_pose",
	disliked_food_addons = {},
	preferred_food_addons = {},

	liked_strike_emotion = cheer_emotion.name,
	disliked_strike_emotion = cheer_emotion.name,
	neutral_strike_emotion = cheer_emotion.name,
}

return npc
