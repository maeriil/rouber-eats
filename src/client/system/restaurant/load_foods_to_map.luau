local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local clientgamedata = require(ReplicatedStorage.client.store.clientgamedata)
local food = require(ReplicatedStorage.common.configs.food)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function setup_food(_server_id: number, food_name: string)
	local server_id = blink_conv.as_entity(_server_id)

	local details = food[food_name]
	assert(details ~= nil, `Food details does not exist for the food {food_name}`)

	local client_id = details.id

	world:add(client_id, c.Food)
	world:set(client_id, c.EntityId, server_id)

	server_id_map.food_map[server_id] = client_id
	clientgamedata.food_map[client_id] = details
end

local function system()
	for _, server_id_list, food_name_list in clientevents.RouberOrders.bulk_setup_food.iter() do
		local n = #server_id_list
		warn(`Setting up food in client!`)

		for i = 1, n do
			local server_id = server_id_list[i]
			local food_name = food_name_list[i]
			warn(`setting up {food_name}`)

			setup_food(server_id, food_name)
		end

		table.clear(food)
		food = nil :: never
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
