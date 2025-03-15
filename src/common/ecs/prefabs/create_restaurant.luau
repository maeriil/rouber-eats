local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local setup_exteriorinterior_building =
	require(ReplicatedStorage.common.utility.setup_exteriorinterior_building)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local function create_restaurant(model: Model, params: types.BuildingRemoteParams)
	local id = ref(model)
	local exterior = model:FindFirstChild("Exterior")
	local interior = model:FindFirstChild("Interior")

	if exterior ~= nil and interior ~= nil then
		setup_exteriorinterior_building(model, params)
	end

	world:add(id, c.Restaurant)
	world:set(id, c.Name, "TestRestaurant")
end

return create_restaurant
