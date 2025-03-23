--[[
  This file should contain all the most commonly used types. When luau releases their v2 solver
  we will need to modify these types as some of the libraries will update too so its useful to have
  a central types

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local greentea = require(ReplicatedStorage.pkg.greentea)
local jecs = require(ReplicatedStorage.pkg.jecs)
local vide = require(ReplicatedStorage.pkg.vide)

export type Entity<T = unknown> = jecs.Entity<T>
export type DeliveryOrderStatus = "NotPickedUp" | "PickedUp" | "Delivered"
export type Source<T> = vide.Source<T>
export type Can<T> = T | (() -> T)
export type GamePages = "HudScreen" | "PhoneScreen" | "RouberScreen"
export type RouberScreenPages = "My Orders" | "Orders" | "My Profile"

export type BuildingRemoteParams = {
	can_enter: boolean,
}

export type DeliveryOrderType = {
	clientid: Entity,
	reward: number,
	restaurant: {
		name: string,
		img: string,
		location: string,
	},
	deliverytype: string,
	distance: number,
}

export type DialogueType = {
	text: string,
	id: Entity,
}

export type ActiveProximity = Entity?

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

return greentea
