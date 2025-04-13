local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local hot_food_condition =
	require(ReplicatedStorage.common.configs.delivery_conditions.hot_food_condition)
local gamedata = require(ServerScriptService.server.store.gamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local playerstore = require(ServerScriptService.server.store.playerstore)
local serverevents = require(ServerScriptService.server.serverevents)

local star_0 = require(ReplicatedStorage.common.configs.rating.star_0)
local star_1 = require(ReplicatedStorage.common.configs.rating.star_1)
local star_2 = require(ReplicatedStorage.common.configs.rating.star_2)
local star_3 = require(ReplicatedStorage.common.configs.rating.star_3)
local star_4 = require(ReplicatedStorage.common.configs.rating.star_4)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local last_fired = require(ReplicatedStorage.common.utility.last_fired)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local all_clients = world:query(c.Client):cached()
local is_not_in_cooldown, update_cooldown = last_fired(1)
local MINIMUM_ORDERS_PER_PLAYER = 7

local function determine_if_should_create_order(list: { Player })
	for client_id, client in all_clients:iter() do
		local store = playerstore[client]
		local config = playersetupconfig[client]

		if not store or not config then
			continue
		end

		if not config.restaurant_setup.client_completed then
			continue
		end

		local num_of_orders = #store.my_orders

		if num_of_orders < MINIMUM_ORDERS_PER_PLAYER and is_not_in_cooldown(client) then
			table.insert(list, client)
		end
	end
end

local hard_pity_to_high_tier = 25
local soft_pity_to_high_tier = 15
local function get_high_tier_success_rate(current_pity: number)
	if current_pity < soft_pity_to_high_tier then
		return 0.085
	elseif current_pity < hard_pity_to_high_tier then
		return 0.3334
	else
		return 1
	end
end

local function weighted_random(weights)
	local total_weight = 0
	for _, weight in ipairs(weights) do
		total_weight = total_weight + weight
	end

	local rand = math.random() * total_weight -- Scale to total weight
	local cumulative = 0

	for tier, weight in ipairs(weights) do
		cumulative = cumulative + weight
		if rand <= cumulative then
			return tier -- Return the selected tier
		end
	end
	return 1 -- Default fallback
end

--[[
  Here are some kind of configs we can have right now?

  max number of orders we can view at a time? 7
  at what point are we guaranteed to get some kind of high tier order? 27
  from what point onwards, do we have higher chance of getting higher tier order? 18
  until then every order is independent. What is the rate of getting high tier? 18%

  Then once we have selected the order tier, now we would need to select restaurants and their
  foods based on this "tier". Tiers are only used to filter out like food kinds. However, even
  within the foods in the same tier, some would have higher pickrate than others, just like
  restaurants, so there would have another layer of rng

  As of now, all houses will be treated equally. But later on, mansions or houses could have
  higher tier and etc too? idk yet
]]

--[[
  For now, we just randomly select a kind of house we want to pick.

]]
local all_house_owners = world:query(c.Name):with(c.HouseOwner):cached()
local function select_a_house_owner()
	local house_owner_list = {}
	for house_owner_id, name in all_house_owners:iter() do
		table.insert(house_owner_list, house_owner_id)
	end

	local random = Random.new(os.clock())
	local index = random:NextInteger(1, #house_owner_list)

	return house_owner_list[index] :: t.Entity
end

--[[
  The way we select restaurant matters so for now we will pass in the tier but not do
    anything about it yet

]]
local all_restaurants =
	world:query(c.Name):with(c.Restaurant):without(c.Interior, c.Exterior):cached()
local function select_a_restaurant(order_tier: number)
	local restaurant_list = {}
	for restaurant_id, name in all_restaurants:iter() do
		table.insert(restaurant_list, restaurant_id)
	end

	local random = Random.new(os.clock())
	local index = random:NextInteger(1, #restaurant_list)

	return restaurant_list[index] :: t.Entity
end

--[[
  We already pass in already filtered out food, so now we just need to go through each of them
  and first weight them according to their rarity. Then we can decide on the details...?

]]

local function select_foods_from_restaurant(foods: { t.RestaurantFoodConfigType })
	--[[
		We need to revamp the way we do this.....
		We are also assuming that we only selected 1 food entity

	]]
	local n = #foods
	local random = Random.new(os.clock())
	local index = random:NextInteger(1, n)

	return foods[index]
end

local function should_create_mystery_box()
	return false
end

local star_ratings = {
	star_0,
	star_1,
	star_2,
	star_3,
	star_4,
}

local function determine_coins_amount(client: Player, is_high_tier: boolean, order_idx: number)
	local datastore = playerdatastore[client]
	local curr_rating_int = math.floor(datastore.rating)

	local coins_weights = if is_high_tier
		then star_ratings[curr_rating_int + 1].high_tier_base_coins
		else star_ratings[curr_rating_int + 1].regular_tier_base_coins

	return coins_weights[order_idx]
end

local function determine_order_rating_amount()
	--[[
		TODO: we are currently unsure whether we should create this here
		or whether rating is a fixed amount of exp. Honestly, fixed sounds like good idea no?
		like basically its based on the order tier

		We should move the rating to there. I think the order tier should have its own config files.
		But does it need to? What would it even contain?

		{
			rating_increase_amount: number;
			rating_decrease_amount: number
		}

		-- The final player rating would be calculated like this?
		return
			order_tier_rating + customer_rating_tier + [some adjustments (?)]
	]]

	return 0.85
end

local function select_order_tier(client: Player)
	local datastore = playerdatastore[client]
	local curr_pity = datastore.orderpity
	local curr_rating_int = math.floor(datastore.rating)

	if curr_rating_int >= 5 then
		error(`We have not implemented a 5 Star player rating mechanism`)
	end

	local success_rate = get_high_tier_success_rate(curr_pity)
	local random = Random.new(os.clock())
	local curr_chance = random:NextNumber()
	local should_be_high_tier = curr_chance <= success_rate
	-- if player rating is 0.something, it becomes 0, but luau array begins from 1
	local weights = if should_be_high_tier
		then star_ratings[curr_rating_int + 1].high_tier_order_weights
		else star_ratings[curr_rating_int + 1].regular_tier_order_weights

	-- This returns an integer from [1, 6], with each representing the tier of the order
	local order_tier = weighted_random(weights)

	if should_be_high_tier then
		-- reset the order pity back to 0 now
		datastore.orderpity = 0
	else
		datastore.orderpity += 1
	end

	return order_tier, should_be_high_tier
end

local function create_orders(list: { Player })
	for _, client in list do
		local client_id = ref(client)
		local livestore = playerstore[client]

		local selected_order_tier, is_high_tier = select_order_tier(client)
		local order_dest_owner_id = select_a_house_owner()
		local residence_id = world:exists_get(order_dest_owner_id, c.Residence)

		local restaurant_id = select_a_restaurant(selected_order_tier)
		local restaurant_config_data = gamedata.restaurant_map[restaurant_id]
		local foods = restaurant_config_data.foods
		local selected_food = select_foods_from_restaurant(foods)
		local order_base_rating = determine_order_rating_amount()

		local order_id = world:entity()
		local delivery_details: t.DeliveryOrderDetailsComponentType = {
			restaurant_id = restaurant_id,
			destination_id = residence_id,
			foods_list_id = { selected_food.id },
			conditions_list_id = {
				-- Conditions aren't created yet
				hot_food_condition.entity_id,
			},
			order_tier = selected_order_tier,
		}

		warn(`[SERVER ORDER]: Created an order with entity id {order_id}`)

		-- Coins reward should be created with some formula using the rarity of
		-- restaurant + foods + house + order combnined
		local coins_reward = determine_coins_amount(client, is_high_tier, selected_order_tier)
		local should_have_mystery_box = should_create_mystery_box()

		world:set(order_id, c.DeliveryOrderDetails, delivery_details)
		if should_have_mystery_box then
			world:add(order_id, c.HasMysteryBox)
		end

		world:set(order_id, c.Roubins, coins_reward)
		world:set(order_id, c.Rating, order_base_rating)
		world:set(order_id, c.Gems, 0)
		world:add(order_id, pair(c.Client, client_id))
		world:add(order_id, c.Vacant)

		serverevents.RouberOrders.create_order.fire(client, blink_conv.from_entity(order_id), {
			conditions_list_id = delivery_details.conditions_list_id,
			destination_id = delivery_details.destination_id,
			foods_list_id = delivery_details.foods_list_id,
			order_tier = delivery_details.order_tier,
			restaurant_id = delivery_details.restaurant_id,
		}, {
			coins = coins_reward,
			gems = 0,
			has_mystery_box = should_have_mystery_box,
		})

		table.insert(livestore.my_orders, order_id)
		update_cooldown(client)
	end
end

local players_to_create_orders_for = {}
local function system()
	determine_if_should_create_order(players_to_create_orders_for)
	create_orders(players_to_create_orders_for)

	players_to_create_orders_for = {}
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
