local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local star_1 = require(ReplicatedStorage.common.configs.rating.star_1)
local star_2 = require(ReplicatedStorage.common.configs.rating.star_2)
local star_3 = require(ReplicatedStorage.common.configs.rating.star_3)
local star_4 = require(ReplicatedStorage.common.configs.rating.star_4)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local rating_configs = {
	star_1,
	star_2,
	star_3,
	star_4,
}

local function validate_rating(player: Player, going_next: number): boolean
	local datastore = playerdatastore[player]
	local config = rating_configs[going_next]

	local delivered_check = datastore.total_orders_delivered >= config.conditions.min_orders_delivered
	local stolen_check = datastore.total_orders_stolen >= config.conditions.min_orders_stolen
	local altered_check = datastore.total_orders_altered >= config.conditions.min_orders_altered

	warn(`{player.Name} met delivery req? {delivered_check}`)
	warn(`{player.Name} met stolen req? {stolen_check}`)
	warn(`{player.Name} met altered req? {altered_check}`)

	return delivered_check and stolen_check and altered_check
end

local function increase_rating()
	for client_id, client, rating, increase_amount in
		world:query(c.Client, c.Rating, p.IncreaseRating):iter()
	do
		warn(`We want to increaes client rating from {rating} by adding {increase_amount}`)
		local new_rating = rating + increase_amount
		local curr_int_rating = math.floor(rating)
		local next_int_rating = math.floor(new_rating)
		local going_next_tier = curr_int_rating ~= next_int_rating
		local datastore = playerdatastore[client]

		if going_next_tier then
			--[[
				determine if we pass the checks. If we do, our new rating is going to be changed
					otherwise we clamp it to the max
			]]
			local should_cap = false

			if new_rating >= 5 then
				warn(`WE HAVEN't IMPLEMENTED 5 Star RATING YET!!`)
				should_cap = true
			else
				should_cap = not validate_rating(client, next_int_rating)
			end

			if should_cap then
				new_rating = next_int_rating
			end
		end

		world:set(client_id, c.Rating, new_rating)
		datastore.rating = new_rating
		world:remove(client_id, p.IncreaseRating)

		warn(`Final client rating is {new_rating}`)
	end
end

local function decrease_rating()
	--//TODO : implement this
end

local function system()
	increase_rating()
	decrease_rating()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
