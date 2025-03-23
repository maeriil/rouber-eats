local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local setup_door = require(script.Parent.setup_door)
local world = require(ReplicatedStorage.common.ecs.world)

--[[
	Should only be called on client really
	We might have more things to add here tbh. Not sure as of yet
]]
local exterior_path = workspace.House :: Folder
local function setup_building_exterior(exterior: Model)
	local house_id, cleanup_house = ref(exterior)
	local root = exterior.PrimaryPart
	assert(
		root ~= nil,
		`Primary part is not defined for the exterior model {exterior.Name}`
	)

	world:set(house_id, c.Model, exterior)
	world:add(house_id, c.Exterior)
	world:set(house_id, c.Cleanup, cleanup_house)

	setup_door(exterior, house_id)
	exterior.Parent = exterior_path

	return house_id
end

return setup_building_exterior
