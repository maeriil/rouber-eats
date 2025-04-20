-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)

local p                 = require(ReplicatedStorage.common.ecs.pairs)
local c                 = require(ReplicatedStorage.common.ecs.components)
local world             = require(ReplicatedStorage.common.ecs.world)
local next_order        = require(ReplicatedStorage.common.utility.next_order)
local __                = jecs.Wildcard

--[[
   Here, we iterate over all the vacant landplots that isn't claimed by any players.
   We setup the NPC and their house
]]
local all_vacant_plots = world
	:query(p.Transform(c.DoormatZone), p.Transform(c.TeleportZone))
	:with(c.LandPlot, c.Vacant)
	:without(p.EntityId(c.ClaimedBy)) -- Ensure we are ignoring the ones that are claimed by new player
	:cached()
-- stylua: ignore end

local n = next_order()
local function system()
	for plot_id in all_vacant_plots:iter() do
		-- For each of them, we need to spawn an npc entity and setup a house owner for them
		-- then we will attempt to setup the land plot
		local npc_model = workspace:WaitForChild("Noob")

		local npc_id = world:entity()
		world:set(npc_id, p.EntityId(c.Claimed), plot_id)
		world:set(npc_id, p.Create(c.Model), npc_model)
		world:set(npc_id, c.Name, `Noob_{n()}`)
		world:add(npc_id, c.HouseOwner)

		world:set(plot_id, p.EntityId(c.ClaimedBy), npc_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
