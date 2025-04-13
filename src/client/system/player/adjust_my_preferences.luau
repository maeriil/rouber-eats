-- stylua: ignore start
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local jecs               = require(ReplicatedStorage.pkg.jecs)
local phases             = require(ReplicatedStorage.common.ecs.phases)
local uistore            = require(ReplicatedStorage.client.app.uistore)
local update_preferences = require(ReplicatedStorage.common.events.player.player_update_preferences)

local c                  = require(ReplicatedStorage.common.ecs.components)
local p                  = require(ReplicatedStorage.common.ecs.pairs)
local t                  = require(ReplicatedStorage.types)
local pair               = jecs.pair
local world              = require(ReplicatedStorage.common.ecs.world)
local __                 = jecs.Wildcard
-- stylua: ignore end

type poses = t.Array<t.rouber_pose_category_t>
local function fire_to_server()
	local my_pref = world:query(c.Request):with(c.UpdateMyPreferences):iter()
	local id, _payload = my_pref()
	if not id then
		return
	end

	local payload = _payload :: () -> (poses, poses)
	local likes, dislikes = payload()
	assert(typeof(likes) == "table" and typeof(dislikes) == "table")

	update_preferences.to_server(likes, dislikes)
	world:delete(id)
end

local from_server = update_preferences.from_server()
local function update_server_results()
	for _, status, my_likes, my_dislikes in from_server.iter() do
		if not status.success then
			print(`Request failed with {status.error_msg}`)
			-- display it to ui now
		else
			uistore.poses_that_i_like(my_likes)
			uistore.poses_that_i_dislike(my_dislikes)
			-- show a ui popup that says update successful
		end
	end
end

local function system()
	fire_to_server()
	update_server_results()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
