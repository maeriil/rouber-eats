-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local poses = require(ReplicatedStorage.common.configs.poses)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local tr = require(ReplicatedStorage.common.ecs.target)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local try_strike_order_pose_event = require(ReplicatedStorage.common.events.order.try_strike_order_pose_event)
local throw_error = require(ReplicatedStorage.common.utility.throw_error)
local __ = jecs.Wildcard
-- stylua: ignore end

--[[
  TODO: This system isnt fully completed yet i dont think
  WE should double check how to do the errors here, and whether or not we even care if it even errors

  For ex, if the pose is invalid, we can always play the default pose

  If the order is invalid, this honestly can never happen, unless someone is spoofing the remote
  in which case, I don't really care, i can just mark it as invalid n they can continue

  If the house_id is nil or dont exist, now this is where it gets interesting, it basically means
  the house was replaced while we were in cutscene. What to do?
    Well, when we first create order, we should immediately add the preferred poses and etc details
    to the order itself. We don't send this to the client. Next, we will add all the info related
    to the house owner to the order itself as well. Finally, the destination_id will always point to
    the land lot instead of house_id.

  This way, the "house_id" will never be nil, and will behave as expected. Requires some code refactors
  that Ill push for later i think
]]

local function end_with_failure(player: Player, error_msg: string)
	warn(error_msg)
	try_strike_order_pose_event.to_client(player, {
		success = false,
		error_msg = error_msg,
	}, "default_deliver_pose", "cheer_emotion")
end

local function try_strike_pose(player: Player, order_id: t.Entity?, pose_kind: t.rouber_pose_t?)
	if
		not order_id
		or not world:contains(order_id)
		or not world:has(order_id, c.DeliveryOrderDetails)
	then
		end_with_failure(player, `Provided an invalid order id`)
		return
	end

	if not pose_kind or not poses[pose_kind] then
		end_with_failure(player, `Provided an invalid pose kind`)
		return
	end

	local order_details = world:exists_get(order_id, c.DeliveryOrderDetails)
	local house_id = order_details.destination_id
	local pose_details = poses[pose_kind]
	local category = pose_details.category
	local success: t.error_handling_status_t = {
		error_msg = "",
		success = true,
	}

	if house_id == nil then
		throw_error(`{script.Name}: house_id is nil, this is a bad issue to occur`)
		return
	end

	-- 	--//TODO: we should change this tbh, and instead have house_id have single Owner component
	-- 	-- and instead add Tag like NPC/Client etc if needed
	local owner_id = world:exists_get(house_id, c.OccupiedByNPC)
		or world:exists_get(house_id, c.OccupiedByPlayer)
	local owner_preferences = world:exists_get(owner_id, c.PreferredPoseCategory)
	world:set(order_id, c.Pose, pose_kind)

	if table.find(owner_preferences.likes, category) then
		try_strike_order_pose_event.to_client(player, success, "default_deliver_pose", "hooray_emotion")
	elseif table.find(owner_preferences.dislikes, category) then
		try_strike_order_pose_event.to_client(player, success, "default_deliver_pose", "frown_emotion")
	else
		try_strike_order_pose_event.to_client(player, success, "default_deliver_pose", "cheer_emotion")
	end
end

local strike_pose_event = try_strike_order_pose_event.from_client()
local function system()
	for _, player, order_id, pose in strike_pose_event.iter() do
		try_strike_pose(player, order_id, pose :: never)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
