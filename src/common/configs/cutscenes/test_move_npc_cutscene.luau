local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local create_cutscene = require(ReplicatedStorage.common.utility.create_cutscene)
local npc_related = require(ReplicatedStorage.common.configs.cutscenes.utils.npc_related)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local CUTSCENE = create_cutscene.CUTSCENE
local SCENE = create_cutscene.SCENE
local action = create_cutscene.action

local function cutscene_move_npc(npc: Model)
	assert(npc.PrimaryPart)
	local walk_to = npc_related.npc_walk_to
	local origin = npc.PrimaryPart.Position

	return CUTSCENE {
		SCENE {
			action(walk_to, npc, vector.create(0, 0, 0), 16),
		},
	}
end

return cutscene_move_npc
