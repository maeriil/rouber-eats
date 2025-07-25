-- stylua: ignore start
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local basepartmap        = require(ReplicatedStorage.client.store.basepartmap)
local gizmo              = require(ReplicatedStorage.common.utility.gizmo)
local jecs               = require(ReplicatedStorage.pkg.jecs)
local try_drop_off_event = require(ReplicatedStorage.common.events.order.try_drop_off_order_event)

local c                  = require(ReplicatedStorage.common.ecs.components)
local t                  = require(ReplicatedStorage.types)
local p                  = require(ReplicatedStorage.common.ecs.pairs)
local phases             = require(ReplicatedStorage.common.ecs.phases)
local world              = require(ReplicatedStorage.common.ecs.world)
local __                 = jecs.Wildcard
-- stylua: ignore end

local function on_door_check(part: BasePart)
	local id = basepartmap[part]
	if id == nil or not world:contains(id) or not world:has(id, c.DoormatZone) then
		return false
	end

	if world:has(c.Client, c.IsCutscenePlaying) then
		-- if cutscene is playing then we dont want to do things like tp or open door etc
		return true
	end

	world:set(id, c.CastStatus, true)
	return true
end

local function on_teleport_check(part: BasePart)
	local id = basepartmap[part]
	if id == nil or not world:contains(id) or not world:has(id, c.TeleportZone) then
		return false
	end

	if world:has(id, p.TPCooldown) then
		return true
	end

	if world:has(c.Client, c.IsCutscenePlaying) then
		return true
	end

	--TODO: we might want to not cast and direclty send event to server, who knows
	world:set(id, c.CastStatus, true)
	return true
end

local cached = world
	:query(c.OverParams, c.PrimaryPart, c.Radius)
	:with(c.Client)
	:without(c.IsCutscenePlaying)
	:cached()
local should_visualize = false

local function system()
	-- local params, hrp, radius = world:get(c.Client, c.OverParams, c.PrimaryPart, c.Radius)
	local it = cached:iter()
	local e, params, hrp, radius = it()
	if not e then
		return
	end

	local current_pos = hrp.Position

	local result = workspace:GetPartBoundsInRadius(current_pos, radius, params)
	local set = {}

	if should_visualize then
		gizmo.sphere.drawWithStyle({
			alwaysOnTop = true,
			color = Color3.fromRGB(255, 0, 0),
			transparency = 0.5,
		}, current_pos, radius)
	end

	for _, instance in result do
		local id = basepartmap[instance]
		if id ~= nil and world:contains(id) and world:has(id, c.HasCutscene) then
			if world:has(id, c.HasOrderToBeDelivered) then
				local exterior_id = world:parent(id)
				local parent_id = world:exists_get(exterior_id, c.Parent)
				local server_parent_id = world:exists_get(parent_id, c.EntityId)

				try_drop_off_event.to_server(server_parent_id :: t.Entity)
				world:remove(id, c.HasOrderToBeDelivered)
			end
		end

		if set[instance] then
			continue
		end

		if on_door_check(instance) or on_teleport_check(instance) then
			table.insert(set, instance)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.PreUpdate,
	runConditions = {},
}
