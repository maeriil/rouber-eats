-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local uistore           = require(ReplicatedStorage.client.app.uistore)
local food              = require(ReplicatedStorage.common.configs.food)
local restaurant        = require(ReplicatedStorage.common.configs.restaurant)
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)
local throw_error       = require(ReplicatedStorage.common.utility.throw_error)

local t                 = require(ReplicatedStorage.types)
local c                 = require(ReplicatedStorage.common.ecs.components)
local world             = require(ReplicatedStorage.common.ecs.world)
local __                = jecs.Wildcard

local should_update_orders_list = world
  :query(c.UI_EVENT)
  :with(c.UI_update_orders_list)
  :cached()

local vacant_orders_to_display = world
	:query(c.DeliveryOrderDetails, c.Roubins, c.EntityId)
	:with(c.Vacant)
	:cached()
-- stylua: ignore end

local function system()
	local it = should_update_orders_list:iter()
	local id = it()
	if not id then
		return
	end

	local orders_map = {} :: { [string]: t.DeliveryOrderType }

	for client_id, details, roubins, server_id in vacant_orders_to_display:iter() do
  -- stylua: ignore start
    local key               = tostring(server_id)
    local conditions        = details.conditions_list_id
    local restaurant_name   = details.restaurant_id
    local restaurant_config = restaurant[restaurant_name]
		local food_list = details.foods_list_id
		local foods_list_display_type = {} :: { t.DeliveryOrderFoodType }
    local house_name = `//TODO: server needs to send this`
		-- stylua: ignore end

		if restaurant_config == nil then
			throw_error(`Could not locate {restaurant_name}'s configs.`, 1)
			continue
		end
		for i, food_name in food_list do
			local client_food_details = food[food_name]
			if client_food_details == nil then
				throw_error(`Could not locate {food_name}'s configs.`, 1)
				continue
			end

			local to_add: t.DeliveryOrderFoodType = {
				image = client_food_details.display_image,
				name = client_food_details.display_name,
				rarity = client_food_details.rarity_value,
			}

			table.insert(foods_list_display_type, to_add)
		end

  -- stylua: ignore start
		orders_map[key] = {
      delivery_type      = "//TODO",
			-- we have not worked on this yet
      has_mystery_box    = false,
      house_address      = house_name,
      house_name         = house_name,
      order_id           = client_id :: t.Entity,
			-- We have not worked on this yet
      order_rating       = details.order_tier,
      restaurant_address = `debug-orderid={client_id}, vacant={world:has(client_id, c.Vacant)}`,
      restaurant_image   = restaurant_config.display_image,
      restaurant_name    = restaurant_config.display_name,
      reward_amount      = roubins,
      foods_list         = foods_list_display_type,
      conditions         = conditions,
		}
		-- stylua: ignore end
	end

	uistore.DeliveryOrderList(orders_map)
	world:delete(id)
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
