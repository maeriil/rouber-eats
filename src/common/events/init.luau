local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local yetanothernet = require(ReplicatedStorage.pkg.yetanothernet)
type Entity<T = unknown> = types.Entity<T>
type Config = yetanothernet.Configuration
type Route<U...> = yetanothernet.Route<U...>

local route = yetanothernet.Route

local standard = {
	Channel = "Reliable",
	Event = "default",
} :: Config

-- local unreliable = {
-- 	Channel = "Unreliable",
-- 	Event = "default",
-- } :: Config

return {
	IWantToSwitchJobs = route.new(standard) :: Route<Entity>,
	IWantToClaimResidence = route.new(standard) :: Route<Model>,

	UpdateGlobalResidenceOwnership = route.new(standard) :: Route<Model, Player>,

	-- currency related
	IncreaseCoinCount = route.new(standard) :: Route<number>,
	IncreaseGemCount = route.new(standard) :: Route<number>,
	DecreaseCoinCount = route.new(standard) :: Route<number>,
	DecreaseGemCount = route.new(standard) :: Route<number>,

	-- Instead, we should pass restaurant model, and check if player has some orders on it?
	IWantMyPickupOrderVerified = route.new(standard) :: Route<Model>,

	-- If a player has some order in the restaurant, it will return true, false otherwise
	OrderVerificationStatus = route.new(standard) :: Route<boolean>,

	-- The order of the values are Restaurant, House, {Itmes}
	CreateAnOrderRequest = route.new(standard) :: Route<Entity, Model, Model, { string }>,

	-- Request to accept the order
	IWantToAcceptOrderRequest = route.new(standard) :: Route<Entity>,

	-- Once we reach the player's house, this event should fire. How should the server verify this?
	--[[
		- Check if player owned that order
		- Check if player has claimed the order in their backpack
		- Check if player is within the House's Radius
	]]
	ICompletedOrderRequest = route.new(standard) :: Route<Model>,

	--[[
		When the server verifies that this house order has been delivered, from clients perspective
		we need to display the animation like work at pizza place. So once this event fires
		we do the camera change and etc stuff. In future, we need to pass extra details such as
		if owner isnt in house, we should be doing the send SS option
	]]
	CompletedOrderAnimation = route.new(standard) :: Route<{
		housemodel: Model,
		npcmodel: Model,
		memodel: Model,
	}>,

	-- Creating the buildings stuff to fire to client world
	-- The entity we pass is the server entity id, when we call delete, the model may already
	-- Be destroyed, so we would need to cleanup the ref a bit..
	-- Bulk is mainly used for initial purposes. Initially, the server will send an array of
	-- items and we need to iterate and setup. Once it finishes bulk creating, we fire back
	-- on server, and it will perform next bulk add, and etc etc.
	IFinishedSettingUpHousesInitiially = route.new(standard) :: Route<>,
	IFinishedSettingUpRestaurantInitiially = route.new(standard) :: Route<>,
	IWantToTeleportInOrOut = route.new(standard) :: Route<Entity, boolean>,
	IHaveLoadedIn = route.new(standard) :: Route<>,
	PlayerLoadIn = route.new(standard) :: Route<Entity>, -- Servre entity id of the player

	SetupMapOnJoin = route.new(standard) :: Route<>,
	IHaveSetupMapToWorkspace = route.new(standard) :: Route<>,
	-- Server to client events

	-- Events for when player first joins the game

	--[[
		BulkCreateHouseOwners is the event we use to mass create the house owners model and send it to the\
		player who just joined. This is used for when we need to animate the order delivery\
		@params Entity This is the server entity id of the provided model (house owner)\
		@params Model This is the npc model\
		@params boolean This refers to whether this model is a npc or not
	]]
	BulkCreateHouseOwners = route.new(standard) :: Route<{ Entity }, { string }, { boolean }>,

	--[[
		BulkCreateHouse is the event we use to mass create the houses and send it to the player who just joined\
		The client will render out the exterior on their own, we do need to however pass the interior model to client so\
		so they can setup the doors and etc on their end\
		@params Entity This is the parent house server entity id. Parent house contains both interior and exterior id\
		@params CFrame This CFrame refers to the doormat zone's CFrame. The client will render the exterior such that exterior's doormat is on this CFrame\
		@params Model This is the interior house model. Client will need to iterate over the houses inside this and attach Billboards to it\
		@params string This is the string refering to what exterior model to create. Client will use this, do a lookup, and clone exterior\
		@params Entity This is the server owned entity id. Each house is owned by someone, whether its a player or NPC.

	]]
	BulkCreateHouses = route.new(standard) :: Route<{ Entity }, { CFrame }, { Model }, { string }, { Entity }>,

	--[[
			BulkCreateRestaurant is the event we use to mass create the restaurants and send it to the player who just joined.\
			The client will render out the exterior on their own, we however pass in the interior model to client so they can setup\
			the doors and etc on their end\
			@params Entity This is the parent restaurant entity id. Parent restaurant contains both interior and exterior id\
			@params string This is the name of the restaurant. In the client side, it needs to do a lookup on the interior/exterior model to connect\
			@params Model This is the interior of the restaurant. Client will need to iterate over it to attach billboard proximity

	]]
	BulkCreateRestaurants = route.new(standard) :: Route<{ Entity }, { string }, { Model }>,

	--[[
			Exact same as the BulkCreateHouseOwners except we only don't fire the table\
			@params Entity This is the server entity id of the provided model (house owner)\
			@params Model This is the npc model\
			@params boolean This refers to whether this model is a npc or not
	]]
	CreateHouseOwner = route.new(standard) :: Route<Entity, string, boolean>,

	--[[
			Exact same as the BulkCreateHouse except we only don't fire the table\
			@params Entity This is the parent house server entity id. Parent house contains both interior and exterior id\
			@params CFrame This CFrame refers to the doormat zone's CFrame. The client will render the exterior such that exterior's doormat is on this CFrame\
			@params Model This is the interior house model. Client will need to iterate over the houses inside this and attach Billboards to it\
			@params string This is the string refering to what exterior model to create. Client will use this, do a lookup, and clone exterior\
			@params Entity This is the server owned entity id. Each house is owned by someone, whether its a player or NPC.
	]]
	CreateHouse = route.new(standard) :: Route<Entity, CFrame, Model, string, Entity>,

	--[[
			DeleteHouseOwner is the event we fire when we need to delete the house owner from client. This can happen in two ways:\
			The first reason could be that a new player has just joined, and we need to replace an existing NPC's house with their house\
			The second reason could be that a player has left the server, and we need to remove them from all client worlds\
			Ensure that in the client we delete the HouseOwner AND their house (interior/exterior as well)\
			@params Entity This is the server entity id of the house owner being deleted
	]]
	DeleteHouseOwner = route.new(standard) :: Route<Entity>,

	-- Client to server events
}
