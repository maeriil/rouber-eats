local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basic_order = require(ReplicatedStorage.common.configs.dialogues.restaurant.basic_order)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local create_house = require(ReplicatedStorage.common.ecs.prefabs.create_house)
local create_restaurant = require(ReplicatedStorage.common.ecs.prefabs.create_restaurant)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local noob = workspace:FindFirstChild("Noob") :: Model
local noob_id = ref(noob)

local function system()
	for _, model, serverid in events.CreateApartment:query():client():iter() do
	end

	for _, model, serverid in events.CreateHouse:query():client():iter() do
		local e, cleanup = ref(model)
		world:set(e, c.Cleanup, cleanup)
		world:set(e, c.EntityId, serverid)

		create_house(model)
	end

	for _, model, serverid in events.CreateRestaurant:query():client():iter() do
		local e, cleanup = ref(model)
		world:set(e, c.Cleanup, cleanup)
		world:set(e, c.EntityId, serverid)

		create_restaurant(model)
		print(`!!! SETTING UP DIALOGUES FOR NOOB`)
		basic_order(noob, model)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
