local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basenpc_dialogue = require(ReplicatedStorage.common.configs.dialogues.basenpc_dialogue)
local basic_order = require(ReplicatedStorage.common.configs.dialogues.restaurant.basic_order)
local cached = require(ReplicatedStorage.common.ecs.cached)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local planck = require(ReplicatedStorage.pkg.planck)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	--system
	local noob = workspace:FindFirstChild("Noob") :: Model
	local noob_id = ref(noob)

	for i, restaurant in cached.get_restaurants:iter() do

		-- warn(
		-- 	"SETUP noob to restaurant.., we should change this so that we setup to restaurant's npc instead"
		-- )
		-- basic_order(noob, restaurant)
	end

	-- basenpc_dialogue(noob)
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {
		planck.runOnce(),
	},
}
