local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)
local t = require(ReplicatedStorage.types)

local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  When a player joins, we want to bulk send the existing landplots to them
  The cleanup landplots runs before this, so we don't accidently send a plot thats going to be deleted
  We simply need to ensure to not send a vacant landplot, the system after this will handle that

  We want to do this for players that do not have landplots setup
]]
local function get_players_who_has_not_setup_houses()
	local players_who_have_not_setup_house = {} :: { Player }

	for i, player in Players:GetPlayers() do
		local player_config = playersetupconfig[player]
		local playerdata = playerdatastore[player]
		if not player_config or not playerdata then
			-- This means that player's data hasn't fully loaded yet. In this case, we simply ignore
			-- and skip them until their data is ready
			continue
		end

		if player_config.house_setup.server_sent then
			-- This means that server has already sent bulk request to this player
			-- We will skip them
			continue
		end

		table.insert(players_who_have_not_setup_house, player)
	end

	return players_who_have_not_setup_house
end

--[[
  Before we send the house details, we need to first setup the house owners in the client side
  A House owner is the person who owns that residence. If it is a player, we need to be careful
  about cloning their character. Archiveable must be set to true. Otherwise it becomes nil
]]
local house_owner_details_query =
	world:query(c.Model, c.PrimaryPart, c.Residence):with(c.HouseOwner):cached()
local request_bulk_create_house_owners = serverevents.Building.bulk_create_house_owners
local function bulk_send_house_owners_with_residence_to_new_players(players: { Player })
	local owner_id_list = {} :: { number }
	local owner_name_list = {} :: { Model }
	local is_npc_list = {} :: { boolean }

	for owner_id, char, primarypart, residence_id in house_owner_details_query:iter() do
		local is_npc = world:has(owner_id, c.OccupiedByNPC)
		assert(char.PrimaryPart ~= nil, `Primary part must be valid`)

		table.insert(owner_id_list, blink_conv.from_entity(owner_id))
		table.insert(owner_name_list, char)
		table.insert(is_npc_list, is_npc)
	end

	request_bulk_create_house_owners.fire_list(
		players,
		owner_id_list,
		owner_name_list :: never,
		is_npc_list
	)
end

--[[
  Now we send the house details to the clients. Because we need to send the server owner id
  we have two queries, one of them is for houses owned by NPC and the other is houses owned by
  player. We insert them to the same arrays however
]]
local npc_house_details_query = world
	:query(c.House, pairs.BuildingExteriorId, pairs.BuildingInteriorId, c.Parent, c.OccupiedByNPC)
	:cached()
local client_house_details_query = world
	:query(c.House, pairs.BuildingExteriorId, pairs.BuildingInteriorId, c.Parent, c.OccupiedByPlayer)
	:cached()
local request_bulk_create_houses = serverevents.Building.bulk_create_house
local function bulk_send_house_details_to_new_players(players: { Player })
	local house_serverid_list = {} :: { t.Entity }
	local house_exteriordoormat_list = {} :: { CFrame }
	local house_interiormodel_list = {} :: { Model }
	local house_type_list = {} :: { string }
	local house_owner_id_list = {} :: { t.Entity }

	for house_id, house_type, exterior_id, interior_id, parent_id, owner_id in
		npc_house_details_query:iter()
	do
		local doormat_cf = world:get(parent_id, pairs.DoormatTransform)
		assert(doormat_cf, `Exterior entity must contain a Transform which is the doormat's CFrmae`)
		local interior_model = world:get(interior_id, c.Model)
		assert(interior_model, `Interior entity must contain a interior model`)
		assert(
			interior_model.PrimaryPart,
			`Before we bulk send, we are ensuring the interior model has a primary part...`
		)

		table.insert(house_serverid_list, house_id)
		table.insert(house_exteriordoormat_list, doormat_cf)
		table.insert(house_interiormodel_list, interior_model)
		table.insert(house_type_list, house_type)
		table.insert(house_owner_id_list, owner_id)
	end

	for house_id, house_type, exterior_id, interior_id, parent_id, owner_id in
		client_house_details_query:iter()
	do
		local doormat_cf = world:get(parent_id, pairs.DoormatTransform)
		assert(doormat_cf, `Exterior entity must contain a Transform which is the doormat's CFrmae`)

		local interior_model = world:get(interior_id, c.Model)
		assert(interior_model, `Interior entity must contain a interior model`)
		assert(
			interior_model.PrimaryPart,
			`Before we bulk send, we are ensuring the interior model has a primary part...`
		)

		table.insert(house_serverid_list, house_id)
		table.insert(house_exteriordoormat_list, doormat_cf)
		table.insert(house_interiormodel_list, interior_model)
		table.insert(house_type_list, house_type)
		table.insert(house_owner_id_list, owner_id)
	end

	for i, player in players do
		-- events.BulkCreateHouses
		-- 	:send(
		-- 		house_serverid_list,
		-- 		house_exteriordoormat_list,
		-- 		house_interiormodel_list,
		-- 		house_type_list,
		-- 		house_owner_id_list
		-- 	)
		-- 	:to(player)
		request_bulk_create_houses.fire(
			player,
			house_serverid_list :: never,
			house_exteriordoormat_list,
			house_interiormodel_list,
			house_type_list,
			house_owner_id_list
		)
	end
end

local function system()
	local players = get_players_who_has_not_setup_houses()

	if #players == 0 then
		return
	end

	bulk_send_house_owners_with_residence_to_new_players(players)
	bulk_send_house_details_to_new_players(players)
	-- Once we have sent, go through each of them and mark their status as completed
	for i, player in players do
		playersetupconfig[player].house_setup.server_sent = true
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.Housing.HousingOnPlayerAdded,
	runConditions = {},
}
