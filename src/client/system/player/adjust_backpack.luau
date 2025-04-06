local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local item_added_event = require(ReplicatedStorage.common.events.backpack.item_added_event)
local item_removed_event = require(ReplicatedStorage.common.events.backpack.item_removed_event)
local t = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function render_backpack_to_source(
	backpack: typeof(c.Backpack.__T),
	changed_items: { t.Entity }
)
	local current = uistore.MyBackpack()
	for i, item in changed_items do
		local item_in_backpack = backpack.items[item]
		current[item] = item_in_backpack
	end

	uistore.MyBackpack(current)
end

local items_added = item_added_event.from_server()
local function on_items_added()
	for _, server_item_id_list, count_list, is_new_list in items_added.iter() do
		local backpack = world:exists_get(c.Client, c.Backpack)
		local n = #server_item_id_list
		local to_send = {}

		for i = 1, n do
			local server_item = server_item_id_list[i]
			local count = count_list[i]
			local is_new = is_new_list[i]
			local client_item = server_id_map.item_map[server_item]

			if is_new then
				backpack.items[client_item] = {
					count = 0,
				}
				--// If we added a new item we should do some specific animation
			end

			local prev = backpack.items[client_item]
			backpack.items[client_item] = {
				count = prev.count + count,
			}
			table.insert(to_send, client_item)
		end
		--[[
			Update the ui store here now..?

			We need to make sure we use values in the UI, so when count changes, ui would update it
			We also DONT want to use table, cuz then it will consider all of them to be different
			if we do need to do that, then instead of sending backpack, we need to send in the items
			that were changes as well, and only update those ones

		]]
		render_backpack_to_source(backpack, to_send)
	end
end

local items_removed = item_removed_event.from_server()
local function on_items_removed()
	for _, server_item_id_list, count_list, is_new_list in items_removed.iter() do
		local backpack = world:exists_get(c.Client, c.Backpack)
		local n = #server_item_id_list
		local to_send = {}

		for i = 1, n do
			local server_item = server_item_id_list[i]
			local count = count_list[i]
			local is_removed = is_new_list[i]

			local client_item = server_id_map.item_map[server_item]

			if is_removed then
				backpack.items[client_item] = nil
			else
				local prev = backpack.items[client_item]
				backpack.items[client_item] = {
					count = prev.count - count,
				}
			end
			table.insert(to_send, client_item)
		end

		--[[
			Update the ui store here now..?

			We need to make sure we use values in the UI, so when count changes, ui would update it
			We also DONT want to use table, cuz then it will consider all of them to be different
			if we do need to do that, then instead of sending backpack, we need to send in the items
			that were changes as well, and only update those ones

		]]
		render_backpack_to_source(backpack, to_send)
	end
end

--//TODO: this function should kinda comp from server i think since server will send the backpack data
local without_backpack = world:query(c.Client):without(c.Backpack):cached()
local function init_backpack_initally()
	local it = without_backpack:iter()
	local client_id = it()

	if client_id then
		world:set(client_id, c.Backpack, {
			items = {},
			slot_kind = 1,
		})
	end
end

local function system()
	init_backpack_initally()
	on_items_added()
	on_items_removed()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
