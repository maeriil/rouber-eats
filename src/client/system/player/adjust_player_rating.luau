local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local player_rating_event = require(ReplicatedStorage.common.events.player.player_rating_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local rating_from_server = player_rating_event.from_server()
local function system()
	for _, new_rating, changing_tier in rating_from_server.iter() do
		if changing_tier then
			warn(`Since we are changing tier, we should be doing large animation`)
		end

		uistore.MyRating(new_rating)
		world:set(c.Client, c.Rating, new_rating)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
