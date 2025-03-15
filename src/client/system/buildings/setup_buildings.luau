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
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--//TODO: remove this
local noob = workspace:FindFirstChild("Noob") :: Model
local noob_id = ref(noob)

local function setup_the_house_req(
	model: Model,
	serverid: types.Entity,
	params: types.BuildingRemoteParams
)
	local e, cleanup = ref(model)
	world:set(e, c.Cleanup, cleanup)
	world:set(e, c.EntityId, serverid)

	print(`house = `, params)

	create_house(model, params)
end

local function setup_the_restaurant_req(
	model: Model,
	serverid: types.Entity,
	params: types.BuildingRemoteParams
)
	local e, cleanup = ref(model)
	world:set(e, c.Cleanup, cleanup)
	world:set(e, c.EntityId, serverid)
	print(`restaurant = `, params)

	create_restaurant(model, params)
	basic_order(noob, model)
end

local function setup_the_apartment_req(
	model: Model,
	serverid: types.Entity,
	params: types.BuildingRemoteParams
)
end

local function system()
	--[[
		These are the initial bulk creation when client first joins. When we successfully create it
		we should let the server know so server can queue the next batch of stuff to create
		The reason we use this approach is because there might be an order of how an item should be created as we
		might assume some components/data may exist
	]]
	for _, models, server_ids, params in events.BulkCreateApartments:query():client():iter() do
		for k = 1, #server_ids do
			setup_the_apartment_req(models[k], server_ids[k], params[k])
		end
		events.IFinishedSettingUpAptsInitiially:send()
	end
	for _, models, server_ids, params in events.BulkCreateHouses:query():client():iter() do
		print(`in bulk create house `, params)
		for k = 1, #server_ids do
			setup_the_house_req(models[k], server_ids[k], params[k])
		end
		events.IFinishedSettingUpHousesInitiially:send()
	end
	for _, models, server_ids, params in events.BulkCreateRestaurants:query():client():iter() do
		print(`in bulk create restuarantd `, params)

		for k = 1, #server_ids do
			setup_the_restaurant_req(models[k], server_ids[k], params[k])
		end
		events.IFinishedSettingUpRestaurantInitiially:send()
	end

	--[[
		These are the regular setups for buildings
	]]
	for _, model, serverid, params in events.CreateApartment:query():client():iter() do
	end
	for _, model, serverid, params in events.CreateHouse:query():client():iter() do
		setup_the_house_req(model, serverid, params)
	end
	for _, model, serverid, params in events.CreateRestaurant:query():client():iter() do
		setup_the_restaurant_req(model, serverid, params)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
