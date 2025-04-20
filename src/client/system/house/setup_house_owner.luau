-- stylua: ignore start
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local server_id_map     = require(ReplicatedStorage.client.store.server_id_map)
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)

local t                 = require(ReplicatedStorage.types)
local c                 = require(ReplicatedStorage.common.ecs.components)
local ref               = require(ReplicatedStorage.common.ecs.ref)
local world             = require(ReplicatedStorage.common.ecs.world)
local throw_error       = require(ReplicatedStorage.common.utility.throw_error)
local attributes        = require(ReplicatedStorage.types.attributes)
local tags              = require(ReplicatedStorage.types.tags)
local __                = jecs.Wildcard
-- stylua: ignore end

local function setup_house_owner(model: Model)
	local owner_server_id = model:GetAttribute(attributes.serverid) :: t.Entity
	local house_owner_name = model.Name

	if owner_server_id == nil then
		throw_error(`The server id for the house owner {house_owner_name} does not exist.`, 2)
		return
	end

	local owner_id = ref(model)
	world:add(owner_id, c.HouseOwner)
	world:set(owner_id, c.EntityId, owner_server_id)
	world:set(owner_id, c.Name, house_owner_name)
	world:set(owner_id, c.Model, model)

	server_id_map.residence_owner_map[owner_server_id] = owner_id

	model:SetAttribute(attributes.clientid, owner_id)
end

-- When a player joins an already existing server, we will query all the existing house owner
-- models. They are guaranteed to be persistent so we should be able to easily set them up
local instance_added = CollectionService:GetTagged(tags.HouseOwner)
CollectionService:GetInstanceAddedSignal(tags.HouseOwner):Connect(function(instance: Instance)
	if not instance:IsA("Model") then
		return
	end

	if instance:GetAttribute(attributes.clientid) ~= nil then
		return
	end

	table.insert(instance_added, instance)
end)

local function system()
	for i = #instance_added, 1, -1 do
		local owner_model = instance_added[i]
		warn(`Setting up the house owner {owner_model.Name}`)

		setup_house_owner(owner_model)

		instance_added[i] = nil
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.PreUpdate,
	runConditions = {},
}
