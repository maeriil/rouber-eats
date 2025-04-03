local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planck = require(ReplicatedStorage.pkg.planck)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local buildings = require(ReplicatedStorage.common.store.buildings)
local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair
local __ = jecs.Wildcard

type BaseBuildingType = buildings.BaseBuildingType

-- local function for_all(e: Entity, model: Model)
-- 	-- For all kinds of residence, these are the things we must add/always have
-- 	-- Primary part is used to identify where to teleport the player if they need to step inside the house
-- 	local root = model.PrimaryPart
-- 	if root == nil then
-- 		error(
-- 			`The building {model.Name} does not have a primary part. A primary part must exist for all building`
-- 		)
-- 		return
-- 	end

-- 	world:set(e, c.PrimaryPart, root)
-- 	world:set(e, c.Position, root.Position :: never)

-- 	local entry = {} :: BaseBuildingType

-- 	-- The doormat is used for teleporting the player when they leave the residence
-- 	local door_mat = model:FindFirstChild("DoorMat") :: Part?
-- 	if door_mat == nil then
-- 		error(
-- 			`The bulding {model.Name} does not contain a doormat. A doormat must exist for all building`
-- 		)
-- 	end

-- 	local door_mat_e = world:entity() :: Entity
-- 	local door_mat_params = OverlapParams.new()
-- 	door_mat_params:AddToFilter({ door_mat } :: { any })
-- 	world:set(door_mat_e, c.DoorMat, door_mat)
-- 	world:set(door_mat_e, c.Position, door_mat.Position :: never)
-- 	world:add(door_mat_e, pair(ChildOf, e))
-- 	world:set(door_mat_e, c.OverParams, door_mat_params)
-- 	entry.DoorMat = door_mat_e

-- 	local door = model:FindFirstChild("Door") :: Model?
-- 	if door == nil then
-- 		error(
-- 			`The building {model.Name} does not contain a door. Every building must contain at least one door even if we can't go inside`
-- 		)
-- 	end
-- 	local door_root = door.PrimaryPart
-- 	if door_root == nil then
-- 		error(
-- 			`{model.Name}'s door does not have primary part. Every door must contain a primary part, and everything else must be attached to it`
-- 		)
-- 	end

-- 	local door_e = world:entity() :: Entity
-- 	world:add(door_e, c.Door)
-- 	world:set(door_e, c.Model, model)
-- 	world:set(door_e, c.PrimaryPart, door_root)
-- 	world:set(door_e, c.Position, door_root.Position :: never)
-- 	entry.Door = door_e

-- 	buildings[e] = entry
-- end

-- local function system()
-- 	-- initially I want to query for all houses and place them in world
-- 	local aptunittag = "ApartmentUnit"
-- 	local housetag = "House"
-- 	local apttag = "Apartment"

-- 	local apt_unit_list = CollectionService:GetTagged(aptunittag)
-- 	local house_list = CollectionService:GetTagged(housetag)
-- 	local apt_list = CollectionService:GetTagged(apttag)

-- 	for _, model in apt_list do
-- 		if not model:IsA("Model") then
-- 			continue
-- 		end

-- 		-- We need to add more details such as Address, World Position, and others?
-- 		-- To make our lives easy, each apt model also needs a root part to hold the position
-- 		local e = ref(model)
-- 		world:add(e, c.Apartment)
-- 		world:set(e, c.Model, model)

-- 		local root = model.PrimaryPart
-- 		if root == nil then
-- 			error(
-- 				`{model.Name} doesnt ont have primary part. Every apartment must contain a primary part which is used to store position`
-- 			)
-- 		end
-- 		world:set(e, c.PrimaryPart, root)
-- 		world:set(e, c.Position, root.Position)

-- 		-- apt the building itself wont have residence since we can only live inside the unit
-- 		-- not the building if that makes sense
-- 	end

-- 	for _, model in apt_unit_list do
-- 		if not model:IsA("Model") then
-- 			continue
-- 		end

-- 		local parent_apt = model:FindFirstAncestorOfClass("Model")
-- 		if not parent_apt then
-- 			error(`Parent apt must exist before adding apartment's unit`)
-- 		end
-- 		local parent_unit = ref(parent_apt)
-- 		local e = ref(model)
-- 		world:add(e, c.Apartment)
-- 		world:add(e, pair(c.AptUnitOf, parent_unit))
-- 		world:add(e, c.ApartmentUnit)
-- 		world:set(e, c.Model, model)
-- 		world:set(e, c.Residence, c.ApartmentUnit)

-- 		for_all(e, model)
-- 		warn(`incomplete req for apt?`)
-- 	end

-- 	-- for _, model in house_list do
-- 	-- 	if not model:IsA("Model") then
-- 	-- 		continue
-- 	-- 	end

-- 	-- 	local e = ref(model)
-- 	-- 	world:add(e, c.House)
-- 	-- 	world:set(e, c.Residence, c.House)
-- 	-- 	world:set(e, c.Model, model)

-- 	-- 	for_all(e, model)
-- 	-- 	warn(`incomplete req for house?`)
-- 	-- end
-- end

local function system() end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {
		planck.runOnce(),
	},
}
