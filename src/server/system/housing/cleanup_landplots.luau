local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local pair = jecs.pair
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function get_players_who_has_setup_houses()
	local players_who_have_setup_house = {} :: { Player }

	for i, player in Players:GetPlayers() do
		local player_config = playersetupconfig[player]
		if player_config and player_config.house_setup.client_completed then
			table.insert(players_who_have_setup_house, player)
		end
	end

	return players_who_have_setup_house
end

local function mark_orders_as_invalid(house_id: t.Entity, landplot_id: t.Entity, owner_id: t.Entity)
	--[[
		TODO: We will need to fire to client world so they can cleanup the order??
		We still haven't deleted it btw.

	]]
	for order_id, details in world:query(c.DeliveryOrderDetails):iter() do
		local residence_id = details.destination_id

		if residence_id == house_id then
			--[[
				if the house to deletes owner is a player who is leavign, then we just force delete
				the order right here...
				How do we know that its the player leaving though?
			]]

			local order_client_id = world:target(order_id, c.Client) :: t.Entity

			print(`order client id = {order_client_id}`)
			print(`they are the same ?? = {owner_id == order_client_id}`)

			if owner_id == order_client_id then
				world:delete(order_id)
				continue
			end

			warn(`Found an order for a house we are about to delete. Marking it as invalid!!`)
			world:add(order_id, c.Invalid)

			if world:has(order_id, p.ClaimedBy) then
				warn(`OKay.... so someone has accepted it.... We need to adjust it now..`)
				world:add(landplot_id, pair(c.HasOrderToBeDelivered, order_id))
			end
		end
	end
end

local function cleanup_the_landplot(
	house_id: t.Entity,
	parent: t.Entity,
	interior_id: t.Entity,
	exterior_id: t.Entity,
	owner_id: t.Entity
)
	local cleanup_interior_model = world:get(interior_id, c.Cleanup)
	assert(cleanup_interior_model, `We have used ref to create interior model. We need to cleanup`)

	cleanup_interior_model()
	mark_orders_as_invalid(house_id, parent, owner_id)
	--//TODO: tbhm we have the parent id here, maybe we can just change the destination in order
	--// once we know the new house id becomes?

	world:remove(parent, c.Residence)
	world:add(parent, c.Vacant)

	-- Technically we should jsut be able to delete house_id and exterior and interior would get deleted too
	-- But i think being explicit makes more sense in long run
	world:delete(exterior_id)
	world:delete(interior_id)
	world:delete(house_id)
end

--[[

  There are two reasons for cleanup to occur on a landplot. The first reason is due to
  a new player joining the server, which means we need to cleanup a NPC's plot so we can
  accomodate our new player.

  Something to keep in mind is that: What if we cleanup a plot while another player is delivering to this
  house. What happens. Even worse, what if they are in middle of cutscene?
]]

local cleanup_house_npc_query = world
	:query(c.Parent, c.OccupiedByNPC, p.BuildingInteriorId, p.BuildingExteriorId)
	:with(c.Cleanup, c.House)
	:cached()
local request_delete_house = serverevents.Building.delete_house_owner
local function cleanup_npc_landplot()
	local players_who_have_completed_setup = get_players_who_has_setup_houses()

	for house_id, parent, npc_owner_id, interior_id, exterior_id in cleanup_house_npc_query:iter() do
		-- This event should only be fired to players who have completed the house setup
		-- Otherwise, we are sending an unknown npc_owner_id to them. In order to be bug free
		-- server will filter out the players to send to. The housing setup runs after this phase
		-- so we are guaranteed that this list contains players who has setup this npc

		print(
			`Cleaning up the existing npc landplot and sending it to the following users {players_who_have_completed_setup}`
		)
		request_delete_house.fire_list(players_who_have_completed_setup, npc_owner_id :: never)
		cleanup_the_landplot(house_id, parent, interior_id, exterior_id, npc_owner_id)

		world:remove(parent, c.OccupiedByNPC)
		world:delete(npc_owner_id)
	end
end

--[[
  The second  reason is due to a player removing event. When a player is removed from game
  we will need to destroy and cleanup their land lot. The Player removing system will ensure that
  it adds a cleanup component to the landlot. This will be implemented later
]]
local cleanup_house_client_query = world
	:query(c.Parent, c.OccupiedByPlayer, p.BuildingInteriorId, p.BuildingExteriorId)
	:with(c.Cleanup, c.House)
	:cached()
local function cleanup_removed_player_landplot()
	local players_who_have_completed_setup = get_players_who_has_setup_houses()

	for house_id, parent, player_id, interior_id, exterior_id in cleanup_house_client_query:iter() do
		print(
			`Cleaning up the players landplot and sending it to the following users {players_who_have_completed_setup}`
		)
		request_delete_house.fire_list(players_who_have_completed_setup, player_id :: never)
		cleanup_the_landplot(house_id, parent, interior_id, exterior_id, player_id)

		world:remove(parent, c.OccupiedByPlayer)
	end
end

local function system()
	cleanup_npc_landplot()
	cleanup_removed_player_landplot()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.Housing.HousingCleanup,
	runConditions = {},
}
