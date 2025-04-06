local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local item_added_event = require(ReplicatedStorage.common.events.backpack.item_added_event)
local item_removed_event = require(ReplicatedStorage.common.events.backpack.item_removed_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  Something to keep in mind. Lets say a players backpack is full, but they stil like

  It might be a better idea for this function to not have a sucess/failure system
  and insteead deligate that part to the function that prompted this system. For ex

  Player goes to a restaurant and decides to steal
  Ok, so we send a condition verification to server, server will then figure out whether
  player has space in backpack or not. And if it doesnt', it will mark it as invalid and
  dialogue will move to failure branch

  Now when it is successfuly, then server will mark it to increase, and increase will just
  increase it without doing any verifications. So this is a dumb system

]]

local function add_item_to_backpack()
	for client_id, client, backpack, item_to_add in
		world:query(c.Client, c.Backpack, pair(c.BackpackItem, c.Increase)):iter()
	do
		local item_list = {} :: { t.Entity }
		local count_list = {} :: { number }
		local is_new_list = {} :: { boolean }

		for i, details in item_to_add do
			local item_to_add_id = details.item_id :: t.Entity
			local count = details.count

			local is_new = backpack.items[item_to_add_id] == nil
			local new_item = backpack.items[item_to_add_id] or {
				count = 0,
			}

			new_item.count += count
			backpack.items[item_to_add_id :: never] = new_item

			table.insert(item_list, item_to_add_id)
			table.insert(count_list, count)
			table.insert(is_new_list, is_new)
		end

		world:remove(client_id, pair(c.BackpackItem, c.Increase))
		item_added_event.to_client(client, item_list, count_list, is_new_list)
	end
end

local function remove_item_from_backpack()
	for client_id, client, backpack, item_to_remove in
		world:query(c.Client, c.Backpack, pair(c.BackpackItem, c.Decrease)):iter()
	do
		local item_list = {} :: { t.Entity }
		local count_list = {} :: { number }
		local is_removed_list = {} :: { boolean }

		for i, details in item_to_remove do
			local item_to_remove_id = details.item_id :: t.Entity
			local count = details.count
			local item = backpack.items[item_to_remove_id]
			assert(item ~= nil, `Item must exist at this point`)

			item.count -= count

			local is_fully_removed = false

			if item.count <= 0 then
				backpack.items[item_to_remove_id] = nil
				is_fully_removed = true
			else
				backpack.items[item_to_remove_id] = item
			end

			table.insert(item_list, item_to_remove_id)
			table.insert(count_list, count)
			table.insert(is_removed_list, is_fully_removed)
		end

		item_removed_event.to_client(client, item_list, count_list, is_removed_list)
		world:remove(client_id, pair(c.BackpackItem, c.Increase))
	end
end

local function system()
	add_item_to_backpack()
	remove_item_from_backpack()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
