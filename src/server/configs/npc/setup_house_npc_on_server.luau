local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local noob = Workspace:FindFirstChild("Noob") :: Model
local runtime_folder = ReplicatedStorage.runtimeasset :: Folder
local runtime_npc = runtime_folder:FindFirstChild("npc") :: Folder

local order = next_order()

local function setup_house_npc_on_server(initial_setup: boolean)
	local npc = noob:Clone()
	npc.Name = `Noob {order()}`
	npc.Parent = runtime_npc

	local root = npc.PrimaryPart
	assert(root, `NPC {npc.Name} does not have primary part defined. This is a bug`)

	local npc_id, cleanup_npc = ref(npc)
	world:set(npc_id, c.Model, npc)
	world:set(npc_id, c.PrimaryPart, root)
	world:add(npc_id, c.NPC)
	world:set(npc_id, c.Cleanup, cleanup_npc)
	world:add(npc_id, c.HouseNPC)
	world:add(npc_id, c.HouseOwner)

	if not initial_setup then
		-- We only fire the remote event if it isn't initial setup.
		-- Initial setup is when server starts initially, and there are no players
		events.CreateHouseOwner:send(npc_id, npc, true)
	end

	return npc, npc_id
end

return setup_house_npc_on_server
