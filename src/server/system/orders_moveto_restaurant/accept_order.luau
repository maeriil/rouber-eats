local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local components = require(ReplicatedStorage.common.ecs.components)
-- local events = require(ReplicatedStorage.common.events)
local jecs = require(ReplicatedStorage.pkg.jecs)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local planck_run = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local pair = jecs.pair
local c = components

-- warn(`The accept order system needs to handle proper error handlings for displaying to UI`)
local function system()
	-- for _, player, serverid in events.IWantToAcceptOrderRequest:query():server():iter() do
	-- 	--[[
	-- 		TODO:
	-- 		what other checks do we need to add?
	-- 			- Check if order exists
	-- 			- Check if order is already in use
	-- 	]]
	-- 	local player_id = ref(player)
	-- 	if serverid == nil then
	-- 		warn(`sent an undefined serverid to the server. Aborting request`)
	-- 		continue
	-- 	end

	-- 	if not world:contains(serverid) or not world:has(serverid, c.DeliveryOrderDetails) then
	-- 		warn(`The delivery order {serverid} does not exist. It may have never existed or expired`)
	-- 		continue
	-- 	end

	-- 	local another_userid = world:target(serverid, c.Claim)
	-- 	if another_userid ~= nil and another_userid ~= player_id then
	-- 		warn(`Another user has already claimed this order. Aborting request`)
	-- 		continue
	-- 	end

	-- 	if another_userid == player_id then
	-- 		warn(`You have already accepted the order!`)
	-- 		continue
	-- 	end

	-- 	if not world:has(player_id, c.IsWorking) then
	-- 		warn(`Player is not working atm, changing the working status to working`)
	-- 		world:add(player_id, c.IsWorking)
	-- 	end

	-- 	world:add(serverid, pair(c.Claim, player_id))

	-- 	-- We want to add the Order Progression status here
	-- 	-- We want to add what items this order would hold as well?
	-- 	local house_id, restaurant_id =
	-- 		world:get(serverid, pair(c.EntityId, c.House), pair(c.EntityId, c.Restaurant))
	-- 	assert(house_id ~= nil, "House id must exst in the serverid")
	-- 	assert(restaurant_id ~= nil, "House id must exst in the serverid")

	-- 	local e = world:entity()
	-- 	world:add(e, pair(c.WorkingAt, serverid))
	-- 	world:add(e, pairs.childof(player_id))
	-- 	world:set(e, pair(c.EntityId, c.House), house_id)
	-- 	world:set(e, pair(c.EntityId, c.Restaurant), restaurant_id)
	-- 	world:set(e, c.DeliveryOrderStatus, "NotPickedUp")

	-- 	local store = playerstore[player]
	-- 	table.insert(store.active_orders, e)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
