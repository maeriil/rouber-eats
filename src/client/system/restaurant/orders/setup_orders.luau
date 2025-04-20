-- stylua: ignore start
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local server_id_map      = require(ReplicatedStorage.client.store.server_id_map)
local jecs               = require(ReplicatedStorage.pkg.jecs)
local phases             = require(ReplicatedStorage.common.ecs.phases)
local create_order_event = require(ReplicatedStorage.common.events.order.create_order_event)

local t                  = require(ReplicatedStorage.types)
local c                  = require(ReplicatedStorage.common.ecs.components)
local world              = require(ReplicatedStorage.common.ecs.world)
local __                 = jecs.Wildcard
-- stylua: ignore end

local orders_to_create = create_order_event.from_server()
local function system()
	for _, server_order_id, details, reward_details in orders_to_create.iter() do
		--[[
      The destination_id is most likely nil in the client world. What info do we need to know
      about them to begin with? Maybe we can directly send them from server
    ]]
		local order_id = world:entity()
		world:set(order_id, c.EntityId, server_order_id)
		world:set(order_id, c.DeliveryOrderDetails, details)
		world:set(order_id, c.Roubins, reward_details.roubins)
		world:add(order_id, c.Vacant)

		if reward_details.has_mystery_box then
			world:add(order_id, c.HasMysteryBox)
		end

		server_id_map.order_map[server_order_id] = order_id :: t.Entity
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
