local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function setup_house_owner(server_owner_id: t.Entity, name: string, is_npc: boolean)
	local owner_id = world:entity()
	world:add(owner_id, c.HouseOwner)
	world:set(owner_id, c.EntityId, server_owner_id)
	world:set(owner_id, c.Name, name)

	if is_npc then
		-- We found an npc
		world:add(owner_id, c.NPC)
		world:add(owner_id, c.HouseNPC)
	end
end

local function system()
	-- for _, server_id_list, owner_name_list, is_npc_list in
	-- 	events.BulkCreateHouseOwners:query():client():iter()
	-- do
	-- 	local n = #server_id_list

	-- 	warn(`Bulk setting up house {n} owners `)

	-- 	for i = 1, n do
	-- 		local server_owner_id = server_id_list[i]
	-- 		local owner_name = owner_name_list[i]
	-- 		local is_npc = is_npc_list[i]

	-- 		setup_house_owner(server_owner_id, owner_name, is_npc)
	-- 	end
	-- end

	-- for _, server_owner_id, owner_model, is_npc in events.CreateHouseOwner:query():client():iter() do
	-- 	warn(`>> Setting up house owner`)
	-- 	setup_house_owner(server_owner_id, owner_model, is_npc)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Client.GeneralSetups.Setup,
	runConditions = {},
}
