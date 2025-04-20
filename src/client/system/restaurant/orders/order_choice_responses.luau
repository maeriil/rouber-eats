-- stylua: ignore start
local ReplicatedStorage             = game:GetService("ReplicatedStorage")
local jecs                          = require(ReplicatedStorage.pkg.jecs)
local phases                        = require(ReplicatedStorage.common.ecs.phases)
local restaurant_general_dialogues  = require(ReplicatedStorage.common.configs.dialogues.restaurant.restaurant_general_dialogues)
local server_id_map                 = require(ReplicatedStorage.client.store.server_id_map)
local try_alter_order_event         = require(ReplicatedStorage.common.events.order.try_altering_order_event)
local invoke_delivering_order_event = require(ReplicatedStorage.common.events.order.invoke_delivering_order_event)
local try_keeping_order_event       = require(ReplicatedStorage.common.events.order.try_keeping_order_event)
local throw_error                   = require(ReplicatedStorage.common.utility.throw_error)

local c                             = require(ReplicatedStorage.common.ecs.components)
local p                             = require(ReplicatedStorage.common.ecs.pairs)
local world                         = require(ReplicatedStorage.common.ecs.world)
local __                            = jecs.Wildcard
-- stylua: ignore end

local deliver_order_response = invoke_delivering_order_event.from_server()
local function on_deliver_order()
	for _, server_house_id, server_order_id in deliver_order_response.iter() do
		-- this is the house_id we are meant to deliver too
		-- At here, we want to add details that the house has potential cutscene
		local client_house_id = server_id_map.residence_map[server_house_id]
		if client_house_id == nil then
			throw_error(
				`The client house id was found to be nil. This means we aren't setting up house properly initally.`
			)
			return
		end

		local exterior_id = assert(
			world:get(client_house_id, p.EntityId(c.Exterior)),
			"Exterior Id of the house must exist"
		)

		local doormat_zone_id =
			assert(world:target(exterior_id, c.DoormatZone), "Doormat zone id of the house must exist")

		--//BUG: When multiple orders are on a same house, we only perform cutscene once...
		world:add(doormat_zone_id, c.HasCutscene)
		world:add(doormat_zone_id, c.HasOrderToBeDelivered)

		local client_order_id = server_id_map.order_map[server_order_id]
		if client_order_id == nil then
			throw_error(`server_order_id does not contain the server id {server_order_id}`)
			return
		end

		warn(`We added details to ensure we are dropping off order!!`)

		world:add(client_order_id, c.ToDropOff)
	end
end

--[[
	TODO: Once the order is marked as ToKeep, what do we do with it on client?
		Similarly what do we do with it in server? Delete it???
]]
local keep_order_response = try_keeping_order_event.from_server()
local function on_keep_order()
	for _, status, server_order_id in keep_order_response.iter() do
		restaurant_general_dialogues.steal_success_signal:fire(status.success, status.error_msg)

		local client_order_id = server_id_map.order_map[server_order_id]
		if client_order_id == nil then
			throw_error(`server_order_id does not contain the server id {server_order_id}`)
			return
		end

		world:add(client_order_id, c.ToKeep)
	end
end

local alter_order_response = try_alter_order_event.from_server()
local function on_alter_order()
	for _, status, server_order_id in alter_order_response.iter() do
		local error_msg = `@{script.Name}, on_alter_order is not created yet`
		warn(error_msg)
		restaurant_general_dialogues.alter_success_signal:fire(false, error_msg)

		local client_order_id = server_id_map.order_map[server_order_id]
		if client_order_id == nil then
			throw_error(`server_order_id does not contain the server id {server_order_id}`)
			return
		end

		world:add(client_order_id, c.ToAlter)
	end
end

local function system()
	on_deliver_order()
	on_keep_order()
	on_alter_order()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
