local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local function setup_npc(npc: Model)
	local root = npc.PrimaryPart
	assert(root, `NPC {npc.Name} does not have primary part defined. This is a bug`)

	local npc_id = ref(npc)
	world:set(npc_id, c.Model, npc)
	world:set(npc_id, c.PrimaryPart, root)
	world:add(npc_id, c.NPC)

	return npc_id
end

return setup_npc
