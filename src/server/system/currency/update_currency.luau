local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for i, client, add_amount, curr_amount in
		world:query(c.Client, pairs.IncreaseCoins, c.Coins):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount + add_amount

		world:set(player_id, c.Coins, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.IncreaseCoinCount:send(add_amount):to(client)
		world:remove(i, pairs.IncreaseCoins)
	end

	for i, client, add_amount, curr_amount in world:query(c.Client, pairs.IncreaseGems, c.Gems):iter() do
		local player_id = ref(client)
		local new_amount = curr_amount + add_amount

		world:set(player_id, c.Gems, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.IncreaseGemCount:send(add_amount):to(client)
		world:remove(i, pairs.IncreaseGems)
	end

	for i, client, remove_amount, curr_amount in
		world:query(c.Client, pairs.DecreaseCoins, c.Coins):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount - remove_amount

		world:set(player_id, c.Coins, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.DecreaseGemCount:send(remove_amount):to(client)
		world:remove(i, pairs.DecreaseCoins)
	end

	for i, client, remove_amount, curr_amount in
		world:query(c.Client, pairs.DecreaseGems, c.Gems):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount - remove_amount

		world:set(player_id, c.Gems, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.DecreaseGemCount:send(remove_amount):to(client)
		world:remove(i, pairs.DecreaseGems)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
