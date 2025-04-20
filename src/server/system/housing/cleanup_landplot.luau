-- stylua: ignore start
local ReplicatedStorage        = game:GetService("ReplicatedStorage")
local jecs                     = require(ReplicatedStorage.pkg.jecs)
local phases                   = require(ReplicatedStorage.common.ecs.phases)

local t                        = require(ReplicatedStorage.types)
local p                        = require(ReplicatedStorage.common.ecs.pairs)
local c                        = require(ReplicatedStorage.common.ecs.components)
local world                    = require(ReplicatedStorage.common.ecs.world)
local delete_house_owner_event = require(ReplicatedStorage.common.events.house.delete_house_owner_event)
local __                       = jecs.Wildcard

local cleanup_house = world
	:query(c.Parent, p.EntityId(c.Interior), p.EntityId(c.Exterior), p.EntityId(c.ClaimedBy))
	:with(c.Cleanup, c.House)
	:cached()
-- stylua: ignore end

--[[
  This can occur whenever a new player joins the game and tries to force remove an existing
  npc landplot

  Or when a player leaves and we now need to cleanup their property
]]
local function system()
	for house_id, plot_id, interior_id, exterior_id, owner_id in cleanup_house:iter() do
		-- The first thing we need to do is cleanup all the orders that are directed to this house
		-- The order invalid system will handle the rest
		for order_id, details in world:query(c.DeliveryOrderDetails):iter() do
			local dest_id = details.destination_id
			if dest_id ~= house_id then
				continue
			end

			--[[
        If the house to delete's owner is a player and this is an order that was created
        for this owner, well, we can just safely delete it now

        To be honest, the order system should be doing this.
        TODO: Can we move it there instead? Maybe by querying all orders that are invalid
        for the player?
      ]]
			local order_client_id = world:target(order_id, c.Client) :: t.Entity
			if owner_id == order_client_id then
				world:delete(order_id)
				continue
			end

			-- Now since the owner is different, this means someone elses order is pointing to this house
			-- we mark it as invalid for now
			-- Additionally, if it has already been accepted, now we are in trouble since we don't want to
			-- change their accepted details. In this case, we ask the order system to instead alter order info

			world:add(order_id, c.Invalid)
			if world:has(order_id, p.EntityId(c.ClaimedBy)) then
				world:add(plot_id, jecs.pair(c.HasOrderToBeDelivered, order_id))
			end
		end

		-- Now we can begin the cleanup process. We simply need to cleanup the interior, and
		-- the exterior models. We can just safely delete it.

		delete_house_owner_event.to_all_clients(owner_id :: t.Entity, house_id :: t.Entity)

		-- If its npc, we need to delete this entity actually
		-- If it is a player we need to delete the
		local is_npc = world:has(plot_id, c.OccupiedByNPC)

		world:remove(plot_id, c.Residence)
		world:add(plot_id, c.Vacant)
		world:delete(exterior_id)
		world:delete(interior_id)
		world:delete(house_id)

		-- The house_id that the owner is considering claiming as
		world:remove(owner_id, p.EntityId(c.Claimed))
		if is_npc then
			world:remove(plot_id, c.OccupiedByNPC)
			world:delete(owner_id)
		else
			world:remove(plot_id, c.OccupiedByPlayer)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
