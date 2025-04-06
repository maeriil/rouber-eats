local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerstore = require(ServerScriptService.server.store.playerstore)
local serverevents = require(ServerScriptService.server.serverevents)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local complete_order_event =
	require(ReplicatedStorage.common.events.restaurant.complete_order_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function try_complete_order_request(player: Player, house_id: t.Entity?)
	local player_id = ref(player)
	local my_orders = playerstore[player].my_pickedup_orders

	warn(`On Complete order req...`)

	if not house_id or not world:contains(house_id) or not world:has(house_id, c.House) then
		warn(`Did not find a valid house info.. Do we still send details to client?`)
		return
	end

	for idx, order_id in my_orders do
		local details = world:exists_get(order_id, c.DeliveryOrderDetails)
		if details.destination_id ~= house_id then
			continue
		end

		table.remove(my_orders, idx)
		local reward_coins, reward_rating = world:exists_get(order_id, c.Coins, c.Rating)
		world:set(player_id, p.IncreaseCoins, reward_coins)
		world:set(player_id, p.IncreaseRating, reward_rating)

		-- order is complete so we should be able to delete it now
		world:delete(order_id)

		-- We need to add cutscene to the house now ...?
		--//TODO: convert this to using regualr remotes soon
		warn(`adding cutscene to the house!!`)

		serverevents.Building.add_cutscene_to_house.fire(player, blink_conv.from_entity(house_id))
		return
	end

	warn(`Could not find a valid ID, do we still send details to client?`)
	return
end

local from_client_event = complete_order_event.from_client()
local function system()
	for _, player, house_id in from_client_event.iter() do
		try_complete_order_request(player, house_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
