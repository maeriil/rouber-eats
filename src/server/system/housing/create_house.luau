-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local buildings_map     = require(ReplicatedStorage.common.configs.buildings.buildings_map)
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)

local p                 = require(ReplicatedStorage.common.ecs.pairs)
local c                 = require(ReplicatedStorage.common.ecs.components)
local ref               = require(ReplicatedStorage.common.ecs.ref)
local world             = require(ReplicatedStorage.common.ecs.world)
local next_order        = require(ReplicatedStorage.common.utility.next_order)
local attributes        = require(ReplicatedStorage.types.attributes)
local tags              = require(ReplicatedStorage.types.tags)
local __                = jecs.Wildcard

local house_to_create = world
  :query(p.Create(c.House), p.EntityId(c.ClaimedBy), p.Transform(c.DoormatZone), p.Transform(c.TeleportZone))
  :with(c.Vacant)
	:without(c.Residence)
  :cached()
-- stylua: ignore end

--//TODO: We want to avoid doing this
local order = next_order()
local function system()
	for plot_id, house_kind, owner_id, doormat_cf, teleport_cf in house_to_create:iter() do
   -- stylua: ignore start
    local folder                 = buildings_map[house_kind]
    local interior_model         = folder.Interior:Clone()
    local interior_root          = interior_model.PrimaryPart :: Part
    local exterior_model         = folder.Exterior:Clone()
    local exterior_root          = exterior_model.PrimaryPart :: Part
    local owner_name             = world:exists_get(owner_id, c.Name)

    local interior_id, cleanup_i = ref(interior_model)
    local exterior_id, cleanup_e = ref(exterior_model)
    local house_id               = world:entity()
    local is_client              = world:has(owner_id, c.Client)

    local client_house_model     = world:exists_get(owner_id, jecs.pair(c.Model, c.HouseOwner))
		-- stylua: ignore end

		warn(`Creating a house for {owner_id}`)

		--//TODO: Dont use order value like this....
		local next_order_value = order()
		interior_model:AddTag(tags.Interior)
		interior_model:AddTag(tags.House)
		interior_model:PivotTo(CFrame.new(0, 100 * next_order_value, 50 * next_order_value))
		interior_model:SetAttribute(attributes.serverid, house_id)
		interior_model.Name = `{owner_name}'s Interior`
		interior_model.Parent = workspace.Interior
		interior_model.ModelStreamingMode = Enum.ModelStreamingMode.Atomic

		exterior_model:AddTag(tags.Exterior)
		exterior_model:AddTag(tags.House)
		exterior_model:SetAttribute(attributes.serverid, house_id)
		exterior_model:PivotTo(
			CFrame.lookAlong(doormat_cf.Position, doormat_cf.LookVector)
				-- We are adding 180 degree rotation cuz our house's root part is rotated 180 degrees
				* CFrame.Angles(0, math.rad(180), 0)
		)
		exterior_model.Name = `{owner_name}'s Exterior`
		exterior_model.Parent = workspace
		exterior_model.ModelStreamingMode = Enum.ModelStreamingMode.Atomic

		world:set(owner_id, c.Residence, house_id)
		client_house_model:SetAttribute(attributes.residence_id, house_id)

		world:set(house_id, c.House, house_kind)
		world:set(house_id, p.EntityId(c.Interior), interior_id)
		world:set(house_id, p.EntityId(c.Exterior), exterior_id)
		world:set(house_id, p.EntityId(c.ClaimedBy), owner_id)
		world:set(house_id, c.Name, owner_name)
		world:set(house_id, c.Parent, plot_id)
		-- world:set(house_id, c.OccupiedByPlayer, client_id)

		world:set(interior_id, c.Parent, house_id)
		world:set(interior_id, c.Model, interior_model)
		world:set(interior_id, c.PrimaryPart, interior_root)
		world:set(interior_id, c.Transform, interior_root.CFrame)
		world:set(interior_id, c.Cleanup, cleanup_i)
		world:set(interior_id, c.Name, owner_name)
		world:add(interior_id, c.Interior)

		world:set(exterior_id, c.Parent, house_id)
		world:set(exterior_id, c.Model, exterior_model)
		world:set(exterior_id, c.PrimaryPart, exterior_root)
		world:set(exterior_id, c.Transform, teleport_cf)
		world:set(exterior_id, c.Cleanup, cleanup_e)
		world:set(exterior_id, c.Name, owner_name)
		world:add(exterior_id, c.Exterior)

		world:set(plot_id, c.Residence, house_id)
		-- world:set(plot_id, c.OccupiedByPlayer, client_id)
		world:remove(plot_id, p.Create(c.House))
		world:remove(plot_id, c.Vacant)
		world:remove(plot_id, p.EntityId(c.ClaimedBy))

		if not is_client then
			world:set(plot_id, c.OccupiedByNPC, owner_id)
			world:set(house_id, c.OccupiedByNPC, owner_id)
		else
			world:set(plot_id, c.OccupiedByPlayer, owner_id)
			world:set(house_id, c.OccupiedByPlayer, owner_id)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
