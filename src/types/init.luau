--[[
  This file should contain all the most commonly used types. When luau releases their v2 solver
  we will need to modify these types as some of the libraries will update too so its useful to have
  a central types

	It might be a good idea to split them up into multiple files, especially for things that are
	specific to a feature / game

	Change the convention to rouber_`type_here`_t
	Primitives can continue to be P
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local greentea = require(ReplicatedStorage.pkg.greentea)
local jecs = require(ReplicatedStorage.pkg.jecs)
local vide = require(ReplicatedStorage.pkg.vide)

export type Array<T> = { T }

-- export type Id<T = unknown> = jecs.Id<T>
export type Id<T = unknown> = jecs.Entity<T>
export type Entity<T = nil> = jecs.Entity<T>
export type Tag = Entity
export type DeliveryOrderStatus = "NotPickedUp" | "PickedUp" | "Delivered"
export type Source<T> = vide.Source<T>
export type Can<T> = T | (() -> T)
export type GamePages =
	"HudScreen"
	| "PhoneScreen"
	| "RouberScreen"
	| "DialogueScene"
	| "BackpackScreen"
	| "pose_screen"
	| "reward_screen"
export type RouberScreenPages = "My Orders" | "Orders" | "My Profile"

export type BuildingRemoteParams = {
	can_enter: boolean,
}

--//TODO remove this shit
export type DeliveryOrderDetailsComponentType = {
	restaurant_id: Entity | Id,
	destination_id: Entity | Id,
	foods_list_id: { Entity | Id },
	conditions_list_id: { Entity | Id },
	order_tier: number,
}

export type DeliveryOrderFoodType = {
	name: string,
	image: string,
	rarity: number,
}

export type rouber_delivery_details_t = {
	restaurant_id: Entity,
	destination_id: Entity,
	foods_list_id: Array<Entity>,
	conditions_list_id: Array<Entity>,
	order_tier: number,
}
export type rouber_deliver_reward_details_t = {
	roubins: number,
	has_mystery_box: boolean,
}

export type DeliveryOrderType = {
	--[[
		I think this should be the client entity id. If it is client, then we need to dispatch
		to ecs world, which will then grab the entity and then send remote event
	]]
	order_id: Entity,

	--[[
		Order rating is basically how valuable this order is. The server calculates it based on the values of
		foods, restaurants, and the house to deliver. Furthermore, only higher level players are
		able to get higher tier orders
	]]
	order_rating: number,
	delivery_type: string, --//NOTE: we only have 1 type rn tbh
	has_mystery_box: boolean,
	reward_amount: number,

	--[[
		Array of food list, we will need to build them up before hand and then send it to client
		so that the client doesn't need to do world:get calls
	]]
	foods_list: { DeliveryOrderFoodType },

	restaurant_image: string,
	restaurant_name: string,
	house_name: string,
	--[[
		TODO: this requires us to actually create a proper map with street names and etc
	]]
	restaurant_address: string,
	house_address: string,
}

export type DialogueType = {
	text: string,
	id: Entity,
}

export type ActiveProximity = Entity?

export type DialogueProximityDetails = {
	adornee: BasePart,
	proximity_text: string, -- This is the dialouge initial_text
	dialogue_id: Entity,
}

export type DoorProximityDetails = {
	adornee: BasePart,
	proximity_text: string,
	exterior: boolean, -- Whether a door is used in exterior vs interior

	-- The id contains the entity id of the proximity prompt it belongs to
	-- we only display the full proximity if it equals to whatever is the ActiveProximtiy
	-- at that moment
	promptid: Entity,
}

export type MailboxProximityDetails = {
	adornee: BasePart,
	owner_text: string,
}

export type ItemProximityDetails = {
	adornee: BasePart,
	item_name: string,

	promptid: Entity,
}

-- We might want to return the greentea here
-- Or create a table of predefined runtimes and return that, whichever we want ot do later on?

--[[
	A Scene is just an array of entites. Where each entities represent some action
]]
export type SceneType = { Entity }

--[[
	A cutscene is therefore just an array of Scenes
]]
export type CutsceneType = { SceneType }

-- Uhhh i should use keyof but it doesn;t exist so doing this manually lmfao
export type BuildingsType = "House_BasicHouse"

--[[
	The general category of the restuarant.
	Source: https://www.webstaurantstore.com/article/353/types-of-restaurants.html

	For all the below categories, we only want to keep ones that we use for now, and
	slowly add more option as we add more dishes
]]
export type RestaurantMainCategory =
	"Fast Food"
	| "Casual"
	| "Fast Casual"
	| "Contemporary Casual"
	| "Fine Dining"
	| "Cafe"
	| "Specialty Drinks"
	| "Buffet"
	| "Food Trucks"
	| "Concession Stands"
	| "Limited Time"

export type NationalityCategory =
	"Any"
	| "American"
	| "Canadian"
	| "British"
	| "Indian"
	| "Chinese"
	| "Korean"
	| "Japanese"
	| "Jamaican"
	| "Nepali"
	| "Thai"
	| "Italian"
	| "French"

export type FoodMainCategory =
	"Coffees and Teas"
	| "Drinks"
	| "Pastries"
	| "Burgers"
	| "Sandwiches"
	| "Burritos"
	| "Sides"
	| "Pizza"
	| "Pasta"
	| "Salads"

--[[
	We will end up wanting to have something like Map<Entity, FoodConfigType> however, I want to be able
	to have server send the entity Id to client and then client just kinda reconstruct it on their own

	For now, when a player joins on startup, ill send a remote event of
		string[], entity[]

	where string = display_name, and entity = server_entity_id

	Then once we have added every single entity to the world, we will do
	Map<ServerEntityId, FoodConfigType>
	If we have the client_id, we can just grab the EntityId which is the server_entity_id
	and its that simple.

	However, bulk sending later on is bad because we would be sending like 100+ array entries
	We could then look to instead preallocate the entities for restaurants/houses and
	do some tricks to ensure the entity id are the same in both server/client

	]]
export type FoodConfigType = {
	--[[
		When we create a food configuration, we are preserving it so we can add them
		to the world when server first starts up. We also need to be able to quickly
		look up the configuration by using a Map<Entity, Config> map
	]]

	id: Entity,
	string_id: string,
	display_name: string,
	display_image: string,

	--[[
		TODO: figure this out more
	]]
	base_value: number,

	--[[
		Rarity value is used to select the food when a restaurant is picked
	]]
	rarity_value: number,

	-- Food conditions
	can_be_hot: boolean,

	category: FoodMainCategory,
	nationality: NationalityCategory,

	-- Ensuring we don't type anything else while we create out config
	[string]: { __sealed_table: true },

	items: { Entity },
}

export type RestaurantFoodConfigType = {
	id: Entity,
	star: { number },
}

export type RestaurantConfigType = {
	id: Entity,
	string_id: string,
	display_name: string,
	display_image: string,
	star: { number },

	--[[
		TODO: Figure this out more
	]]
	base_value: number,
	--[[
		Rarity value is used to select the restaurant when an order is made
	]]
	rarity_value: number,

	category: RestaurantMainCategory,
	nationality: NationalityCategory,

	foods: { RestaurantFoodConfigType },

	-- Ensuring we don't type anything else while we create out config
	[string]: { __sealed_table: true },
}

-- Some rating may have like specific kind of req? how do we determine that? no idea tbh?
-- maybe we can export out a function that validates this
--//TODO LUAU, we should merge the following into a single type and instead use Index type
export type RatingConfigConditionType = {
	min_orders_delivered: number,
	min_orders_stolen: number,
	min_orders_altered: number,

	min_orders_with_5_star_customer_feedback: number,
	min_orders_with_4_star_customer_feedback: number,
}
export type RatingConfigType = {
	conditions: RatingConfigConditionType,
	high_tier_order_weights: { number },
	high_tier_base_coins: { number },
	regular_tier_order_weights: { number },
	regular_tier_base_coins: { number },
}

export type StoreConfigType = {
	id: Entity,
	string_id: string,
	display_name: string,
	display_image: string,
}

export type ItemConfigType = {
	id: Entity,
	string_id: string,
	display_name: string,
	-- no display image since we would use viewport model here
	-- so at runtime, we should do a world:get call and grab the model

	base_price: number,
	rarity: number,
}

export type BackpackItemType = {
	count: number,
}

export type BackpackEnumConfigType = {
	furnishing: number,
	items: number,
}

-- export type game_events_t =
-- 	"event_halloween"
-- 	| "event_Christmas"
-- 	| "event_Diwali"
-- 	| "event_New_Years"
-- 	| "event_CN_New_Years"
-- 	| "event_NP_New_Years"

export type rouber_pose_t = "default_deliver_pose" | "deliver_elegantly"
export type rouber_pose_category_t =
	"cool_pose"
	| "elegant_pose"
	| "spooky_pose"
	| "stylish_pose"
	| "rocky_pose"
	| "quirky_pose"
	| "shy_pose"
	| "confident_pose"
	| "unknown_pose"

export type rouber_house_theme_t = "Spooky" | "Classy" | "Energetic"

export type rouber_npc_config_t = {
	name: string,

	house_type: BuildingsType,
	house_location_id: string,

	preferred_pose_category: rouber_pose_category_t,
	disliked_pose_category: rouber_pose_category_t,

	model: Model,

	-- Some NPC specific conditions, when met they provide additional rewards
	-- These conditions needs to be performed when a player is about to do the delivery to the house
	conditions: Array<Entity>,
	conditions_met_rewards: Array<Entity>,
}

export type rouber_emotion_t =
	"cheer_emotion"
	| "frown_emotion"
	| "happy_emotion"
	| "hooray_emotion"
	| "sob_emotion"

export type error_handling_status_t = {
	success: boolean,
	error_msg: string,
}

export type rouber_delivery_conditions_t = "hot_food_condition"

return greentea
