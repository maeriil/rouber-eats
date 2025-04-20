-- stylua: ignore start
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local setup_door        = require(ReplicatedStorage.common.configs.buildings.setup_door)
local restaurant        = require(ReplicatedStorage.common.configs.restaurant)
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)

local t                 = require(ReplicatedStorage.types)
local p                 = require(ReplicatedStorage.common.ecs.pairs)
local c                 = require(ReplicatedStorage.common.ecs.components)
local ref               = require(ReplicatedStorage.common.ecs.ref)
local world             = require(ReplicatedStorage.common.ecs.world)
local throw_error       = require(ReplicatedStorage.common.utility.throw_error)
local attributes        = require(ReplicatedStorage.types.attributes)
local tags              = require(ReplicatedStorage.types.tags)
local __                = jecs.Wildcard
-- stylua: ignore end

local function setup_restaurant_interior(model: Model)
	--[[
    models are guaranteed to be atomic so we should be able to index the primary part safely
    models should also contain the name of the restaurant it points towards, using the attributes
  ]]

	local restaurant_name = model:GetAttribute(attributes.restaurant_name_id)
	local config = restaurant[restaurant_name]

	if restaurant_name == nil or config == nil then
		throw_error("Could not link a valid restaurant", 2)
		return
	end

	local interior_primary = model.PrimaryPart :: Part
	local display_name = config.display_name
	local parent_id = config.id
	local interior_id = ref(model)
	local server_id = model:GetAttribute(attributes.serverid) :: t.Entity?

	if server_id == nil then
		throw_error(`Serverid for the restaurant {display_name} does not exist.`, 2)
		return
	end

	world:set(parent_id, p.EntityId(c.Interior), interior_id)
	world:set(parent_id, c.EntityId, server_id)

	world:add(interior_id, c.Interior)
	world:set(interior_id, c.Parent, parent_id)
	world:set(interior_id, c.Name, display_name)
	world:set(interior_id, c.Transform, interior_primary.CFrame)
	world:set(interior_id, c.EntityId, server_id)
	world:set(interior_id, c.Model, model)

	setup_door(model, interior_id)
	model:SetAttribute(attributes.clientid, parent_id)
end

local function setup_restaurant_exterior(model: Model)
	--[[
    models are guaranteed to be atomic so we should be able to index the primary part safely
    models should also contain the name of the restaurant it points towards, using the attributes
  ]]

	local restaurant_name = model:GetAttribute(attributes.restaurant_name_id)
	local config = restaurant[restaurant_name]

	if restaurant_name == nil or config == nil then
		throw_error("Could not link a valid restaurant", 2)
		return
	end

	local exterior_primary = model.PrimaryPart :: Part
	local display_name = config.display_name
	local parent_id = config.id
	local exterior_id = ref(model)
	local server_id = model:GetAttribute(attributes.serverid) :: t.Entity?

	if server_id == nil then
		throw_error(`Serverid for the restaurant {display_name} does not exist.`, 2)
		return
	end

	world:set(parent_id, p.EntityId(c.Exterior), exterior_id)
	world:set(parent_id, c.EntityId, server_id)

	world:add(exterior_id, c.Restaurant)
	world:add(exterior_id, c.Exterior)
	world:set(exterior_id, c.Parent, parent_id)
	world:set(exterior_id, c.Name, display_name)
	-- In the client sided, the transform server as a different purpose to server, here it will be
	-- used for pathfinding. It sorta acts as the restaurant's address
	world:set(exterior_id, c.Transform, exterior_primary.CFrame)
	world:set(exterior_id, c.EntityId, server_id)
	world:set(exterior_id, c.Model, model)

	setup_door(model, exterior_id)
	model:SetAttribute(attributes.clientid, parent_id)
end

local instance_added = CollectionService:GetTagged(tags.Restaurant)
CollectionService:GetInstanceAddedSignal(tags.Restaurant):Connect(function(instance: Instance)
	if not instance:IsA("Model") then
		return
	end

	if ref.contains(instance) then
		return
	end

	table.insert(instance_added, instance)
end)

local function system()
	for i = #instance_added, 1, -1 do
		local restaurant_instance = instance_added[i]

		if restaurant_instance:HasTag(tags.Interior) then
			setup_restaurant_interior(restaurant_instance)
		elseif restaurant_instance:HasTag(tags.Exterior) then
			setup_restaurant_exterior(restaurant_instance)
		else
			--[[
				Restaurants r grouped by folder so we might be iterating over that
			]]
			if not restaurant_instance:IsA("Folder") then
				throw_error(`Unknown tag found for the model {restaurant_instance.Name}`)
			end
		end

		instance_added[i] = nil
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
