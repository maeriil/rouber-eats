-- stylua: ignore start
local ReplicatedStorage         = game:GetService("ReplicatedStorage")
local ServerScriptService       = game:GetService("ServerScriptService")
local gamedata                  = require(ServerScriptService.server.store.gamedata)
local get_item_space            = require(ServerScriptService.server.server_utils.get_item_space)
local has_enough_backpack_space = require(ServerScriptService.server.server_utils.has_enough_backpack_space)
local jecs                      = require(ReplicatedStorage.pkg.jecs)
local phases                    = require(ReplicatedStorage.common.ecs.phases)
local playerstore               = require(ServerScriptService.server.store.playerstore)
local try_keeping_order_event   = require(ReplicatedStorage.common.events.order.try_keeping_order_event)

local c                         = require(ReplicatedStorage.common.ecs.components)
local p                         = require(ReplicatedStorage.common.ecs.pairs)
local ref                       = require(ReplicatedStorage.common.ecs.ref)
local t                         = require(ReplicatedStorage.types)
local world                     = require(ReplicatedStorage.common.ecs.world)
local __                        = jecs.Wildcard
local pair                      = jecs.pair
-- stylua: ignore end

local function end_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
	try_keeping_order_event.to_client(player, {
		success = false,
		error_msg = message,
	}, nil :: never)
end

local function try_steal_order_request(player: Player)
	local player_id = ref(player)

	local store = playerstore[player]
	local backpack = world:exists_get(player_id, c.Backpack)

	for idx, my_order_id in store.my_pickedup_orders do
		if not world:has(my_order_id, c.WorkingAt) then
			continue
		end

		-- If in future we want to add cooldown mechanism to it, we can do so here.

		local details = world:exists_get(my_order_id, c.DeliveryOrderDetails)
		local foods_list = details.foods_list_id
		local selected_food_items = {}

		-- Stealing consumes some coins and rating, verify that player has enough
		-- This is because we don't support negative rating and negative coins

		local coins, rating = world:exists_get(player_id, c.Roubins, c.Rating)
		warn(`//TODO: We are hardcoding rating /coinshere!! Change this`)
		local consume_coins = 50
		local consume_rating = 0.85

		if rating - consume_rating < 0 then
			end_with_failure(player, `You do not have enough rating to steal it!`)
			return
		end

		if coins - consume_coins < 0 then
			end_with_failure(player, `You do not have enough coins to steal it!`)
			return
		end

		local foods_count = #foods_list
		for _, food_id in foods_list do
			local food_details = gamedata.food_map[food_id :: t.Entity]
			assert(food_details ~= nil, `Food details cannot be nil here`)

			if #food_details.items == 0 then
				end_with_failure(player, `One of the foods in the delivery is not stealable`)
				return
			end

			-- For each of the item we will need to select the one which player don't own first
			-- then if they own all, we randomly pick on of them

			local item_to_select = nil
			for _, item_id in food_details.items do
				if backpack.items[item_id] == nil then
					item_to_select = item_id
				end
			end
			if item_to_select == nil then
				item_to_select = food_details.items[math.random(1, #food_details.items)]
			end

			table.insert(selected_food_items, item_to_select)
		end

		-- Determine if the players have enough space for it now
		local space_summed = 0
		for _, item in selected_food_items do
			space_summed += get_item_space(item, 1)
		end

		if
			not has_enough_backpack_space(backpack, selected_food_items, table.create(foods_count, 1))
		then
			end_with_failure(
				player,
				`You do not have enough space left in your backpack. Clear up some space!`
			)
			return
		end

		local to_add_to_backpack = {} :: typeof(c.BackpackItem.__T)
		for _, item in selected_food_items do
			table.insert(to_add_to_backpack, {
				count = 1,
				item_id = item,
			})
		end

		-- Once every check passes, we simply add the item to backpack
		world:set(player_id, pair(c.BackpackItem, c.Increase), to_add_to_backpack)
		world:set(player_id, p.Decrease(c.Rating), 0.85)
		world:set(player_id, p.Decrease(c.Roubins), 50)

		try_keeping_order_event.to_client(player, {
			success = true,
			error_msg = ``,
		}, my_order_id :: t.Entity)

		table.remove(store.my_pickedup_orders, idx)
		return
	end

	-- If we reach here, it means we haven't picked up order? just reject it bro
	end_with_failure(player, `You haven't picked up any order to steal it!`)
end

local from_client_event = try_keeping_order_event.from_client()
local function system()
	for _, player in from_client_event.iter() do
		try_steal_order_request(player)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
