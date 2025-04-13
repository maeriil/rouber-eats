local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local without_currency = world:query(c.Client):without(c.Roubins, c.Gems):cached()
local function system()
	for player_id, client in without_currency:iter() do
		local data = playerdatastore[client]
		if data == nil then
			-- The player's data hasnt loaded yet, so we ignore the request and wait next frame
			continue
		end

		--//TODO: update name to roubins
		local coins = data.coins
		local gems = data.gems

		world:set(player_id, c.Roubins, coins)
		world:set(player_id, c.Gems, gems)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
