local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[

  We need to really verify this system more. Here is the scenario

  Game creates an order for house A.
  For some reason house A is deleted (either a player joins, or player leaves)
  Now the order is pointing towards an invalid House.

  We have two options.
    1. Delete the order
    2. Change the order such that it points to the new house on that landplot

  If we did one, then its relatively straight forward, we just delete it and move on
    we do also need to however, tell the client that we should delete that order
  If we did two, then we would need to tell the client to update the details to a new house id
    We would need to find the parent of the house, but thats hard because entity is invalid now...

  Honestly, it might be better to mark an order as deleted WHEN a house is being deleted
  and in here, we can do stuff with it once we find out its invalid...
]]

local function system()
	for order_id, details in world:query(c.DeliveryOrderDetails):iter() do
		local residence_id = details.destination_id
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
