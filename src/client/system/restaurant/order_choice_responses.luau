local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local restaurant_general_dialogues =
	require(ReplicatedStorage.common.configs.dialogues.restaurant.restaurant_general_dialogues)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local alter_order_event = require(ReplicatedStorage.common.events.restaurant.alter_order_event)
local deliver_order_event = require(ReplicatedStorage.common.events.restaurant.deliver_order_event)
local steal_order_event = require(ReplicatedStorage.common.events.restaurant.steal_order_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local deliver_order_response = deliver_order_event.from_server()
local function on_deliver_order()
	for _, server_house_id in deliver_order_response.iter() do
		-- this is the house_id we are meant to deliver too
		-- At here, we want to add details that the house has potential cutscene
		local client_house_id = server_id_map.residence_map[server_house_id]
		if client_house_id == nil then
			error(
				`The client house id was found to be nil. This means we aren't setting up house properly initally.`
			)
			return
		end

		local exterior_id = world:get(client_house_id, p.BuildingExteriorId)
		assert(exterior_id, `Exterior id of the house must exist while we attempt to add cutscen to it`)

		local doormat_zone_id = world:target(exterior_id, c.DoormatZone)
		assert(doormat_zone_id, `Doormat zone id must exist`)

		--//BUG: When multiple orders are on a same house, we only perform cutscene once...
		world:add(doormat_zone_id, c.HasCutscene)
		world:add(doormat_zone_id, c.HasOrderToBeDelivered)
	end
end

local steal_order_response = steal_order_event.from_server()
local function on_steal_order()
	for _, status in steal_order_response.iter() do
		restaurant_general_dialogues.steal_success_signal:fire(status.success, status.error_msg)
	end
end

local alter_order_response = alter_order_event.from_server()
local function on_alter_order()
	for _, status in alter_order_response.iter() do
		local error_msg = `@{script.Name}, on_alter_order is not created yet`
		warn(error_msg)
		restaurant_general_dialogues.alter_success_signal:fire(false, error_msg)
	end
end

local function system()
	on_deliver_order()
	on_steal_order()
	on_alter_order()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
