-- stylua: ignore start
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs                = require(ReplicatedStorage.pkg.jecs)
local playerdatastore     = require(ServerScriptService.server.store.playerdatastore)
local throw_error         = require(ReplicatedStorage.common.utility.throw_error)

local t                   = require(ReplicatedStorage.types)
local c                   = require(ReplicatedStorage.common.ecs.components)
local p               = require(ReplicatedStorage.common.ecs.pairs)
local phases              = require(ReplicatedStorage.common.ecs.phases)
local world               = require(ReplicatedStorage.common.ecs.world)
local __                  = jecs.Wildcard
-- stylua: ignore end

--[[
  There are two ways we can claim a landplot. One is if there already exists a vacant landplot
  that isn't claimed by any other players
]]
local vacant_plot_query = world:query(c.LandPlot):with(c.Vacant):without():cached()
local function claim_vacant_landplot(player_id: t.Entity | t.Id)
	for plot_id in vacant_plot_query:iter() do
		world:set(plot_id, p.EntityId(c.ClaimedBy), player_id)
		world:set(player_id, p.EntityId(c.Claimed), plot_id)
		return true
	end
	return false
end

--[[
  The other is to claim a NPC owned landplot. After the server sets up all the vacant landplot
  once, then more often than not, the second query will run
  When we pick a land lot, we add a Cleanup to it so the other system that deletes it can clear out the area
  If a plot is already set to cleanup, then some other player has claimed it

  It is guaranteed that there exists at least enough landplots as the max number of players in server
]]

-- stylua: ignore start
local plot_owned_by_npc_query = world
	:query(c.Parent, c.Name)
	:with(c.House, c.OccupiedByNPC)
	:without(c.Cleanup)
	:cached()
-- stylua: ignore end
local function claim_npc_owned_landplot(player_id: t.Entity | t.Id)
	for house_id, plot_id, name in plot_owned_by_npc_query:iter() do
		world:add(house_id, c.Cleanup)
		world:set(plot_id, p.EntityId(c.ClaimedBy), player_id)
		world:set(player_id, p.EntityId(c.Claimed), plot_id)

		return true
	end

	throw_error(`Not enough landplots available.`, 2)
	return false
end

local client_without_residence =
	world:query(c.Client):without(c.Residence, p.EntityId(c.Claimed)):cached()
local function system()
	for client_id, client in client_without_residence:iter() do
		local store = playerdatastore[client]
		if not store or not store.housetype then
			continue
		end

		local found_vacant_landplot = claim_vacant_landplot(client_id)
		if found_vacant_landplot then
			continue
		end

		claim_npc_owned_landplot(client_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.WorldSetups,
	runConditions = {},
}
