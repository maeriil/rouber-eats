local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local clientgamedata = require(ReplicatedStorage.client.store.clientgamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local restaurant_general_dialogues =
	require(ReplicatedStorage.common.configs.dialogues.restaurant.restaurant_general_dialogues)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function add_cutscene_to_house(server_house_id: t.Entity)
	local client_house_id = server_id_map.residence_map[server_house_id]
	if client_house_id == nil then
		error(
			`The client house id was found to be nil. This means we aren't setting up house properly initally.`
		)
		return
	end

	local exterior_id = world:get(client_house_id, p.BuildingExteriorId)
	assert(exterior_id, `Exterior id of the house must exist while we attempt to add cutscen to it`)

	local doormat_zone_id = world:target(exterior_id, c.DoormatZone)
	assert(doormat_zone_id, `Doormat zone id must exist`)

	world:add(doormat_zone_id, c.HasCutscene)
	world:add(doormat_zone_id, c.HasOrderToBeDelivered)

	-- local client_id_map = clientgamedata.residence_map[server_house_id]
	-- If this assert fails, then we r pickign up orders for a deleted house
	-- assert(client_id_map ~= nil, `Client id for this housoe should exist? {server_house_id}`)

	-- local door =
end

local function pickingup_order_verification()
	for _, status, _server_house_id, error_msg in
		clientevents.RouberOrders.pickup_order_response.iter()
	do
		-- We need to mark this as picked up. We then need
		warn(`in client we found the result {status}, {error_msg}, sending to signal`)
		if status then
			local server_order_id = blink_conv.as_entity(_server_house_id :: number)
			add_cutscene_to_house(server_order_id)
		end

		restaurant_general_dialogues.verify_order_signal:fire(status, error_msg)
	end
end

local function system()
	pickingup_order_verification()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
