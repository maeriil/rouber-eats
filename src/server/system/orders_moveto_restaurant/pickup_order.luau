local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
-- local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  NOTE
  IWantMyPickupOrderVerified is fired by Dialogue. Which means it expects response in return
  We use events.OrderVerificationStatus to determine the status
  So we MUST fire back even if the event is invalid? or fails

]]

local function system()
	-- for _, player, model in events.IWantMyPickupOrderVerified:query():server():iter() do
	-- 	if not model then
	-- 		warn(`Sent an undefined model to server. Aborting req`)
	-- 		events.OrderVerificationStatus:send(false):to(player)
	-- 		continue
	-- 	end

	-- 	local res_id = ref(model)
	-- 	local player_id = ref(player)

	-- 	if not world:contains(res_id) or not world:has(res_id, c.Restaurant) then
	-- 		warn(`Passed an invalid restaurant, Aborting request`)
	-- 		events.OrderVerificationStatus:send(false):to(player)
	-- 		continue
	-- 	end

	-- 	if not world:has(player_id, c.IsWorking) then
	-- 		warn(`Player is not currently working, so theres no way they can request order. Aborting`)
	-- 		events.OrderVerificationStatus:send(false):to(player)
	-- 		continue
	-- 	end

	-- 	local orders = playerstore[player].active_orders
	-- 	local my_order_id = nil
	-- 	for _, order in orders do
	-- 		local order_res_id = world:get(order, pair(c.EntityId, c.Restaurant)) :: t.Entity
	-- 		-- Here we need to verify that the order is in proper stage too
	-- 		if order_res_id == res_id then
	-- 			my_order_id = order
	-- 			break
	-- 		end
	-- 	end

	-- 	if my_order_id == nil then
	-- 		warn(`Player does not own the order. Request denied`)
	-- 		events.OrderVerificationStatus:send(false):to(player)
	-- 		continue
	-- 	end

	-- 	-- So now they do own the id, now we must verify their status. Have they already picked up?
	-- 	local status: t.DeliveryOrderStatus =
	-- 		world:get(my_order_id, c.DeliveryOrderStatus) :: t.DeliveryOrderStatus
	-- 	if status ~= "NotPickedUp" then
	-- 		warn(`Player has already picked up the order. We can't do anymore `)
	-- 		events.OrderVerificationStatus:send(false):to(player)
	-- 		continue
	-- 	end

	-- 	--//TODO Last verification we need to do is that player position is within the restaurant viscinity

	-- 	-- Now, we can mark the player has picked up the order

	-- 	world:set(my_order_id, c.DeliveryOrderStatus, "PickedUp")
	-- 	events.OrderVerificationStatus:send(true):to(player)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
