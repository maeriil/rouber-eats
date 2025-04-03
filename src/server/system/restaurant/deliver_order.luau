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
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function end_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
end

local function try_deliver_order(player: Player, house_id: t.Entity)
	local player_id = ref(player)

	if not world:contains(house_id) or not world:has(house_id, c.House) then
		end_with_failure(player, `The user passed an invalid id to the server. Ignoring the request`)
		return
	end

	if not world:has(player_id, c.IsWorking) then
		end_with_failure(
			player,
			`Player is not working atm, so they cant possible be delivering order!`
		)
		return
	end

	local pickedup_list = playerstore[player].my_pickedup_orders

	for idx, my_order_id in pickedup_list do
		local details, reward_coins, reward_rating =
			world:exists_get(my_order_id, c.DeliveryOrderDetails, c.Coins, c.Rating)

		if details.destination_id ~= house_id then
			continue
		end

		table.remove(pickedup_list, idx)
		world:set(player_id, p.IncreaseCoins, reward_coins)
		world:set(player_id, p.IncreaseRating, reward_rating)
		world:delete(my_order_id)

		serverevents.Building.add_cutscene_to_house.fire(player, blink_conv.from_entity(house_id))
		return
	end

	end_with_failure(
		player,
		`Could not find a proper order if for the provided house id. Ignoring request`
	)
	return
end

local function system()
	for _, player, _house_id in serverevents.RouberOrders.i_want_to_complete_order.iter() do
		local house_id = blink_conv.as_entity(_house_id)
		try_deliver_order(player, house_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
