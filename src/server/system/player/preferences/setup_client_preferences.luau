-- stylua: ignore start
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs                = require(ReplicatedStorage.pkg.jecs)
local phases              = require(ReplicatedStorage.common.ecs.phases)
local playerdatastore     = require(ServerScriptService.server.store.playerdatastore)

local c                   = require(ReplicatedStorage.common.ecs.components)
local p                   = require(ReplicatedStorage.common.ecs.pairs)
local t                   = require(ReplicatedStorage.types)
local pair                = jecs.pair
local world               = require(ReplicatedStorage.common.ecs.world)
local update_preferences = require(ReplicatedStorage.common.events.player.player_update_preferences)
local __                  = jecs.Wildcard
-- stylua: ignore end

local without_likes = world:query(c.Client):without(c.PreferredPoseCategory):cached()
local function system()
	for player_id, client in without_likes:iter() do
		local data = playerdatastore[client]
		if data == nil then
			-- The player's data hasnt loaded yet, so we ignore the request and wait next frame
			continue
		end

		local unknown_pref: t.rouber_pose_category_t = "unknown_pose"

		--//TODO: we need to grab the likes dislikes from the playerstore
		local likes = { unknown_pref }
		local dislikes = { unknown_pref }

		world:set(player_id, c.PreferredPoseCategory, {
			likes = likes,
			dislikes = dislikes,
		})

		-- Once they are set, fire them to the client world
		warn(`firing this to the client!!`)
		warn(likes)
		warn(dislikes)
		update_preferences.to_client(client, {
			success = true,
			error_msg = ``,
		}, likes, dislikes)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
