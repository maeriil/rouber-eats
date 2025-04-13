-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)

local t                 = require(ReplicatedStorage.types)
local ct                = require(ReplicatedStorage.types.config_types)
local p                 = require(ReplicatedStorage.common.ecs.pairs)
local c                 = require(ReplicatedStorage.common.ecs.components)
local tr                = require(ReplicatedStorage.common.ecs.target)
local pair              = jecs.pair
local world             = require(ReplicatedStorage.common.ecs.world)
local __                = jecs.Wildcard

--[[
  This is for creating preference mechanisms for dynamically spawned NPCs. These npcs are
  only created whenever a player leaves/joins the game, so that empty vacant spaces can be filled.
  For these NPCs, since everything is dynamic, we need to create their preferences as well
]]

local npc_without_ref = world
	:query(c.Name)
  :with(c.HouseNPC, c.HouseOwner)
	:without(c.PreferredPoseCategory)
	:cached()
-- stylua: ignore end

local function setup_preferences_for_npc(npc_id: t.Entity, npc_name: string)
	--[[
    TODO: Later on we will do some random number magics
      For now, we will just mark both of their preferences as unknown
  ]]
	local unknown_pref: t.rouber_pose_category_t = "unknown_pose"

	world:set(npc_id, c.PreferredPoseCategory, {
		likes = { unknown_pref },
		dislikes = { unknown_pref },
	})
end

local function system()
	for npc_id, name in npc_without_ref:iter() do
		setup_preferences_for_npc(npc_id :: t.Entity, name)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
