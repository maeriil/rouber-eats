local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local player_rating_event = require(ReplicatedStorage.common.events.player.player_rating_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local without_rating = world:query(c.Client):without(c.Rating):cached()
local function system()
	for player_id, client in without_rating:iter() do
		local data = playerdatastore[client]
		if data == nil then
			-- The player's data hasnt loaded yet, so we ignore the request and wait next frame
			continue
		end

		world:set(player_id, c.Rating, data.rating)
		player_rating_event.to_client(client, data.rating, false)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
