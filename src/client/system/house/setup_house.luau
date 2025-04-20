-- stylua: ignore start
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local basepartmap       = require(ReplicatedStorage.client.store.basepartmap)
local server_id_map     = require(ReplicatedStorage.client.store.server_id_map)
local setup_door        = require(ReplicatedStorage.common.configs.buildings.setup_door)
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)
local attributes        = require(ReplicatedStorage.types.attributes)
local tags              = require(ReplicatedStorage.types.tags)
local throw_error       = require(ReplicatedStorage.common.utility.throw_error)

local t                 = require(ReplicatedStorage.types)
local p                 = require(ReplicatedStorage.common.ecs.pairs)
local c                 = require(ReplicatedStorage.common.ecs.components)
local ref               = require(ReplicatedStorage.common.ecs.ref)
local world             = require(ReplicatedStorage.common.ecs.world)
local __                = jecs.Wildcard
-- stylua: ignore end

local house_owner_list = world:query(c.Model, c.Name):with(c.HouseOwner):cached()
local function get_house_owner_id(server_house_id: t.Entity): t.Entity?
	for client_id, model, name in house_owner_list:iter() do
		local residence_server_id = model:GetAttribute(attributes.residence_id) :: t.Entity?
		if residence_server_id == nil then
			throw_error(`Could not find a residence id for the owner {name}.`, 2)
			continue
		end

		if residence_server_id == server_house_id then
			return client_id :: t.Entity
		end
	end

	return nil
end

local function setup_parent_house(house_owner_id: t.Entity, house_server_id: t.Entity)
	local residence_id = world:entity() :: t.Entity
	local username = world:exists_get(house_owner_id, c.Name)

	world:set(house_owner_id, c.Residence, residence_id)
	--//TODO: c.House takes in the kind of house its mapped too.. maybe through attribute?
	world:set(residence_id, c.House, "house-kind....")
	world:set(residence_id, c.Name, username)
	world:set(residence_id, c.EntityId, house_server_id)
	--//TODO: I DOnt liek this, remove it..
	world:set(residence_id, c.OccupiedByPlayer, house_owner_id)
	server_id_map.residence_map[house_server_id] = residence_id

	return residence_id
end

local function setup_mailbox(mailbox_base: BasePart, parent: t.Entity, params: OverlapParams)
	local e = world:entity() :: t.Entity
	world:add(parent, jecs.pair(c.Mailbox, e))
	world:set(e, c.Parent, parent)
	world:set(e, c.BasePart, mailbox_base)
	world:add(e, c.Mailbox)

	basepartmap[mailbox_base] = e

	return e
end

local function setup_house_interior(model: Model)
	--[[
    Models are guaranteed to be atomic so we should be able to index primary part safely
    models should also contain the server_id which points to the house id in the server.
    We need to link it to the house owner, what we can do is iterate over all the house owners
    and find out which one of them have the residence id set to the server id.

    All the house owner models will be parented to a folder in ReplicatedStorage. They are
    also guaranteed to be persistent so they should exist at all times. (??)
    NOTE: something I heard is that sometimes persistent models are buggy T_T
  ]]
	local house_server_id = model:GetAttribute(attributes.serverid) :: t.Entity
	local house_name = model.Name
	if house_server_id == nil then
		throw_error(`The house {house_name} does not have a valid server_id.`, 2)
		return
	end

	--[[
    This is the supposedly the client id of the house owner, we need to set the residence
    and etc to it
  ]]
	local house_owner_id = get_house_owner_id(house_server_id :: t.Entity)
	if house_owner_id == nil then
		throw_error(`The house owner for the house {house_name} does not exist.`, 2)
		return
	end

	local interior_id, cleanup = ref(model)
	local interior_root = model.PrimaryPart :: Part
	local residence_id = world:get(house_owner_id, c.Residence) :: t.Entity
	local username = world:exists_get(house_owner_id, c.Name)

	-- if residence_id == nil then
	-- 	-- If the residence is nil, then we haven't set it up for this player yet. We should do
	-- 	-- so now

	-- 	residence_id = world:entity() :: t.Entity
	-- 	world:set(house_owner_id, c.Residence, residence_id)
	-- 	--//TODO: c.House takes in the kind of house its mapped too.. maybe through attribute?
	-- 	world:set(residence_id, c.House, "house-kind....")
	-- 	world:set(residence_id, c.Name, username)
	-- 	world:set(residence_id, c.EntityId, house_server_id)
	-- 	--//TODO: I DOnt liek this, remove it..
	-- 	world:set(residence_id, c.OccupiedByPlayer, house_owner_id)
	-- 	server_id_map.residence_map[house_server_id] = residence_id
	-- end

	if residence_id == nil then
		residence_id = setup_parent_house(house_owner_id, house_server_id)
	end

	world:set(residence_id, p.EntityId(c.Interior), interior_id)

	world:set(interior_id, c.Parent, residence_id)
	world:set(interior_id, c.Model, model)
	world:set(interior_id, c.PrimaryPart, interior_root)
	world:set(interior_id, c.Transform, interior_root.CFrame)
	world:set(interior_id, c.Cleanup, cleanup)
	world:set(interior_id, c.Name, username)
	world:set(interior_id, c.EntityId, house_server_id)
	world:add(interior_id, c.Interior)

	setup_door(model, interior_id)

	model:SetAttribute(attributes.clientid, interior_id)
end

local function setup_house_exterior(model: Model)
	--[[
    Similar to above, we will grab the house owner, and set them up if we need to.
    More often than note, the exterior will be setup first than interior.

    Again, we do something similar, grab the house owner, and check if the residence is setup
    or not. If they havent yet, then we should update it first, and then link them together after
  ]]

	local house_server_id = model:GetAttribute(attributes.serverid) :: t.Entity
	local house_name = model.Name
	if house_server_id == nil then
		throw_error(`The house {house_name} does not have a valid server_id.`, 2)
		return
	end

	--[[
    This is the supposedly the client id of the house owner, we need to set the residence
    and etc to it
  ]]
	local house_owner_id = get_house_owner_id(house_server_id :: t.Entity)
	if house_owner_id == nil then
		throw_error(`The house owner for the house {house_name} does not exist.`, 2)
		return
	end

	local exterior_id, cleanup = ref(model)
	local exterior_root = model.PrimaryPart :: Part
	local residence_id = world:get(house_owner_id, c.Residence) :: t.Entity
	local username = world:exists_get(house_owner_id, c.Name)

	if residence_id == nil then
		residence_id = setup_parent_house(house_owner_id, house_server_id)
	end

	world:set(residence_id, p.EntityId(c.Exterior), exterior_id)
	world:set(exterior_id, c.Parent, residence_id)
	world:set(exterior_id, c.Model, model)
	world:set(exterior_id, c.PrimaryPart, exterior_root)
	world:set(exterior_id, c.Transform, exterior_root.CFrame)
	world:set(exterior_id, c.Cleanup, cleanup)
	world:set(exterior_id, c.Name, username)
	world:set(exterior_id, c.EntityId, house_server_id)
	world:add(exterior_id, c.Exterior)

	setup_door(model, exterior_id)
	local mailbox = model:FindFirstChild("mailbox") :: Model?
	assert(
		mailbox ~= nil,
		`Every exterior house must have a mail box as this is used to identify player`
	)
	assert(mailbox.PrimaryPart ~= nil, `Every mailbox must have a primary part`)
	local mailbox_params = OverlapParams.new()
	mailbox_params:AddToFilter({ mailbox } :: never)
	setup_mailbox(mailbox.PrimaryPart, exterior_id, mailbox_params)

	model:SetAttribute(attributes.clientid, exterior_id)

	print(`For the house, im seeing the attribute {model:GetAttribute(attributes.clientid)}`)
end

local instance_added = CollectionService:GetTagged(tags.House) :: t.Array<Model>
CollectionService:GetInstanceAddedSignal(tags.House):Connect(function(instance: Instance)
	if not instance:IsA("Model") then
		return
	end

	if ref.contains(instance) then
		return
	end

	warn(`>>> REF PASSED, its a new item..`)

	table.insert(instance_added, instance)
end)

local function system()
	for i = #instance_added, 1, -1 do
		local house_instance = instance_added[i]
		warn(`Setting up the house {house_instance.Name}`)

		if house_instance:HasTag(tags.Interior) then
			setup_house_interior(house_instance)
		elseif house_instance:HasTag(tags.Exterior) then
			setup_house_exterior(house_instance)
		else
			throw_error(`Unknown tag found for the model {house_instance.Name}`)
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
