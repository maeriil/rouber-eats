local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local all_restaurant = world:query(c.Name):with(c.Restaurant):cached()

local function system()
	-- for _, restaurant_name_list, restaurant_id_list in
	-- 	events.BulkConnectRestaurantToInterior:query():client():iter()
	-- do
	-- 	-- for i = 1, #restaurant_name_list do
	-- 	-- 	local restaurant_name = restaurant_name_list[i]
	-- 	-- 	local restaurant_interior_serverid = restaurant_id_list[i]
	-- 	-- 	local found = false

	-- 	-- 	for exterior_id, target_restaurant_name in all_restaurant:iter() do
	-- 	-- 		if target_restaurant_name == restaurant_name then
	-- 	-- 			world:set(exterior_id, c.EntityId, restaurant_interior_serverid)
	-- 	-- 			found = true
	-- 	-- 			break
	-- 	-- 		end
	-- 	-- 	end

	-- 	-- 	if not found then
	-- 	-- 		error(
	-- 	-- 			`The client does not contain an exterior restaurant with name {restaurant_name}. This is most likely a bug`
	-- 	-- 		)
	-- 	-- 	end
	-- 	-- end
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
