-- stylua: ignore start
  local ReplicatedStorage  = game:GetService("ReplicatedStorage")
  local jecs               = require(ReplicatedStorage.pkg.jecs)
  local phases             = require(ReplicatedStorage.common.ecs.phases)
  local poses_category     = require(ReplicatedStorage.common.configs.poses_category)
  local update_preferences = require(ReplicatedStorage.common.events.player.player_update_preferences)

  local c                  = require(ReplicatedStorage.common.ecs.components)
  local p                  = require(ReplicatedStorage.common.ecs.pairs)
  local ref                = require(ReplicatedStorage.common.ecs.ref)
  local t                  = require(ReplicatedStorage.types)
  local pair               = jecs.pair
  local world              = require(ReplicatedStorage.common.ecs.world)
  local __                 = jecs.Wildcard
-- stylua: ignore end

type pref_t = t.Array<t.rouber_pose_category_t>
type category_t = t.rouber_pose_category_t

local function end_with_failure(player: Player, error_msg: string)
	warn(`[{script.Name}]: failed with {error_msg}`)
	update_preferences.to_client(player, {
		success = false,
		error_msg = error_msg,
	}, {}, {})
end

local function try_update_preferences(player: Player, likes: pref_t?, dislikes: pref_t?)
	if not likes or not dislikes or typeof(likes) ~= "table" or typeof(dislikes) ~= "table" then
		end_with_failure(player, `Invalid data provided. Aborting req`)
		return
	end

	for _, category: category_t? in likes do
		if poses_category[category] == nil then
			end_with_failure(player, `Could not find a liked pose category of name {category}`)
			return
		end
	end

	for _, category: category_t? in dislikes do
		if poses_category[category] == nil then
			end_with_failure(player, `Could not find a disliked pose category of name {category}`)
			return
		end
	end

	local unknown_pose: category_t = "unknown_pose"
	for _, category: category_t in likes do
		if category == unknown_pose then
			continue
		end

		local found = table.find(dislikes, category)
		if found ~= nil then
			end_with_failure(player, `Cannot have same category {category} in both likes and dislikes`)
			return
		end
	end

	local likes_n = #likes
	local dislikes_n = #dislikes
	if likes_n == 0 then
		table.insert(likes, unknown_pose)
	end
	if dislikes_n == 0 then
		table.insert(dislikes, unknown_pose)
	end

	local player_id = ref(player)
	world:set(player_id, c.PreferredPoseCategory, {
		likes = likes,
		dislikes = dislikes,
	})

	update_preferences.to_client(player, {
		success = true,
		error_msg = ``,
	}, likes, dislikes)
end

local from_client = update_preferences.from_client()
local function system()
	for _, player, likes, dislikes in from_client.iter() do
		try_update_preferences(player, likes, dislikes)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
