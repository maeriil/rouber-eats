local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)

local c = require(ReplicatedStorage.common.ecs.components)
local remotes = require(ReplicatedStorage.types.remotes)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local vacant_order_details =
	world:query(c.DeliveryOrderDetails):with(c.Vacant):without(c.Invalid):cached()
local function system()
	for _, client in world:query(c.Client):iter() do
		local config = playersetupconfig[client]
		if not config then
			continue
		end

		if
			(config.house_setup.client_completed and config.restaurant_setup.client_completed)
			and not config.order_setup.server_sent
		then
			-- time to bulk send
			warn(`time to bulk send to client initally`)
			local server_id_list = {} :: { number }
			local order_details_list = {} :: { remotes.RouberOrders_DeliveryType }
			for server_id, order_details in vacant_order_details:iter() do
				table.insert(server_id_list, server_id :: never)
				table.insert(order_details_list, order_details :: never)
			end

			serverevents.RouberOrders.bulk_create_order.fire(
				client,
				server_id_list,
				order_details_list :: never
			)
			config.order_setup.server_sent = true
		end
	end

	for _, player in serverevents.PlayerEvents.i_have_bulk_created_orders_initially.iter() do
		local config = playersetupconfig[player]
		config.order_setup.client_completed = true
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
