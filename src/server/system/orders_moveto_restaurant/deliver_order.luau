local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
-- local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	--system

	-- for _, player, house in events.ICompletedOrderRequest:query():server():iter() do
	-- 	local player_id = ref(player)

	-- 	if not house then
	-- 		warn(`Passed an invalid house to the server`)
	-- 		continue
	-- 	end

	-- 	local house_id = ref(house)
	-- 	if not world:contains(house_id) or not world:has(house_id, c.House) then
	-- 		warn(`Passed an invalid house. We havent supported apt yet`)
	-- 		continue
	-- 	end

	-- 	if not world:has(player_id, c.IsWorking) then
	-- 		warn(`Player is not working atm, so they cant possible be delivering order`)
	-- 		continue
	-- 	end

	-- 	local order_list = playerstore[player].active_orders
	-- 	local my_order_id = nil
	-- 	for _, order in order_list do
	-- 		local order_house_id = world:get(order, pair(c.EntityId, c.House))
	-- 		if order_house_id == house_id then
	-- 			my_order_id = order
	-- 		end
	-- 	end

	-- 	if my_order_id == nil then
	-- 		warn(`Could not find your order id, aborting..`)
	-- 		continue
	-- 	end

	-- 	local status: t.DeliveryOrderStatus =
	-- 		world:get(my_order_id, c.DeliveryOrderStatus) :: t.DeliveryOrderStatus

	-- 	if status ~= "PickedUp" then
	-- 		warn("Invalid order, aborting")
	-- 		continue
	-- 	end

	-- 	-- Should do a check to see if player is within the house or not (?)
	-- 	world:set(my_order_id, c.DeliveryOrderStatus, "Delivered")

	-- 	local housemodel = world:get(my_order_id, c.Model) :: Model
	-- 	local npcmodel = Instance.new("Model") -- world:get()
	-- 	local memodel = (player.Character :: Model):Clone()

	-- 	events.CompletedOrderAnimation
	-- 		:send({
	-- 			housemodel = housemodel,
	-- 			npcmodel = npcmodel,
	-- 			memodel = memodel,
	-- 		})
	-- 		:to(player)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
