--[[
  This file should contain all the most commonly used types. When luau releases their v2 solver
  we will need to modify these types as some of the libraries will update too so its useful to have
  a central types

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local greentea = require(ReplicatedStorage.pkg.greentea)
local jecs = require(ReplicatedStorage.pkg.jecs)
local vide = require(ReplicatedStorage.pkg.vide)

-- export type Id<T = unknown> = jecs.Id<T>
export type Id<T = unknown> = jecs.Entity<T>
export type Entity<T = nil> = jecs.Entity<T>
export type Tag = Entity
export type DeliveryOrderStatus = "NotPickedUp" | "PickedUp" | "Delivered"
export type Source<T> = vide.Source<T>
export type Can<T> = T | (() -> T)
export type GamePages = "HudScreen" | "PhoneScreen" | "RouberScreen" | "DialogueScene"
export type RouberScreenPages = "My Orders" | "Orders" | "My Profile"

export type BuildingRemoteParams = {
	can_enter: boolean,
}

export type DeliveryOrderFoodType = {
	name: string,
	image: string,
	rarity: number,
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
}

export type RestaurantConfigType = {
	id: Entity,
	string_id: string,
	display_name: string,
	display_image: string,

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

	foods: { Entity },

	-- Ensuring we don't type anything else while we create out config
	[string]: { __sealed_table: true },
}

return greentea
