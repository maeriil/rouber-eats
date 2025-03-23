local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local setup_door = require(script.Parent.setup_door)
local world = require(ReplicatedStorage.common.ecs.world)

--[[
	Should only be called on server (?)
  Something we need to adjust is that we need to find a random position to place it
  in the map. How random that is, not too sure.

  Now that I think about it, we might want to use this in client to. If we think about how we
  do buildings, we need to find a place to save a furnishing. That spatial query cast would be
  done in client and then validated in server right.

]]
local interior_house_path = workspace.Interior :: Folder
local function setup_building_interior(interior: Model)
	local house_id, cleanup_house = ref(interior)
	local root = interior.PrimaryPart
	assert(
		root ~= nil,
		`Primary part is not defined for the interior model {interior.Name}`
	)

	world:set(house_id, c.Model, interior)
	world:set(house_id, c.PrimaryPart, root)
	world:set(house_id, c.Transform, root.CFrame)
	world:add(house_id, c.Interior)
	world:set(house_id, c.Cleanup, cleanup_house)

	setup_door(interior, house_id)

	--//TODO Move this to serverisde
	if RunService:IsServer() then interior.Parent = interior_house_path end

	return house_id
end

return setup_building_interior
