local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local create_restaurant = require(ReplicatedStorage.common.ecs.prefabs.create_restaurant)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local planck = require(ReplicatedStorage.pkg.planck)
local setup_exteriorinterior_building =
	require(ReplicatedStorage.common.utility.setup_exteriorinterior_building)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	local restauranttag = "Restaurant"
	local instances = CollectionService:GetTagged(restauranttag)

	for _, model in instances do
		assert(model:IsA("Model"))
		local id = ref(model)

		create_restaurant(model)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = { planck.runOnce() },
}
