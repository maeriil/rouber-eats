local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local jecs = require(ReplicatedStorage.pkg.jecs)
local opt_get_player = require(ReplicatedStorage.common.utility.opt_get_player)
local ref = require(ReplicatedStorage.common.ecs.ref)
local setup_exteriorinterior_building =
	require(ReplicatedStorage.common.utility.setup_exteriorinterior_building)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

local function create_house(model: Model)
	local id = ref(model)
	local exterior = model:FindFirstChild("Exterior")
	local interior = model:FindFirstChild("Interior")

	if exterior ~= nil and interior ~= nil then
		setup_exteriorinterior_building(model)
	else
		error(`Implement this case...`)
	end

	world:add(id, c.House)
	world:set(id, c.Name, "TestHouse")

	if RunService:IsClient() then
		local exterior_id = world:get(id, pair(c.EntityId, c.Exterior)) :: types.Entity
		local doormat = world:get(exterior_id, c.PrimaryPart) :: Part

		local connection = doormat.Touched:Connect(function(part: BasePart)
			local player = opt_get_player(part)
			if not player then
				return
			end

			local e = ref(player)
			events.ICompletedOrderRequest:send(model)
		end)
	end

	return id
end

return create_house
