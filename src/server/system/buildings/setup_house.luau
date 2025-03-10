local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local create_house = require(ReplicatedStorage.common.ecs.prefabs.create_house)
local planck = require(ReplicatedStorage.pkg.planck)
local ref = require(ReplicatedStorage.common.ecs.ref)
local setup_exteriorinterior_building =
	require(ReplicatedStorage.common.utility.setup_exteriorinterior_building)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function setup_generalhouse(model: Model)
	-- If its a general house, it means only NPC owns it. Which means the player cannot
	-- open the house door unless the NPC themselves open it for them while they are delivering order
	-- It also means we don't need to do the TP setups at all
end

-- We definitely need to turn this into prefabs because consider the case
--[[
	TODO
	Suppose player A haven't joined a game yet. Then the current house is owned by an NPC.
	Now when player A joins, and we pick that spot, then we need to replace the house in that
	location with the player's house, since they could have modified it. What we would do is
	FireAllClient that that npc house is deleted, then FireAllClient with players house
	Which means inside that remote event we need to run the prefabs create_house()
]]
local function system()
	local housetag = "House"
	local instances = CollectionService:GetTagged(housetag)

	for _, model in instances do
		assert(model:IsA("Model"))

		create_house(model)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = { planck.runOnce() },
}
