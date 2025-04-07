local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerstore = require(ServerScriptService.server.store.playerstore)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local deliver_order_event = require(ReplicatedStorage.common.events.restaurant.deliver_order_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function try_deliver_order(player: Player)
	local store = playerstore[player]

	for idx, my_order_id in store.my_pickedup_orders do
		if not world:has(my_order_id, c.WorkingAt) then
			continue
		end

		local details = world:exists_get(my_order_id, c.DeliveryOrderDetails)
		local house_id = details.destination_id :: t.Entity

		world:remove(my_order_id, c.WorkingAt)
		warn(`oka we sending to client to do the house cutscene setu pnow yawn..`)
		deliver_order_event.to_client(player, house_id)
	end

	warn(`we should never reach this point @deliver_order`)
end

local from_client_event = deliver_order_event.from_client()
local function system()
	for _, player in from_client_event.iter() do
		try_deliver_order(player)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
