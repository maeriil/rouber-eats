local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local yetanothernet = require(ReplicatedStorage.pkg.yetanothernet)
type Entity = types.Entity
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
	CompletedOrderAnimation = route.new(standard) :: Route<>,

	-- Creating the buildings stuff to fire to client world
	-- The entity we pass is the server entity id, when we call delete, the model may already
	-- Be destroyed, so we would need to cleanup the ref a bit..
	-- Bulk is mainly used for initial purposes. Initially, the server will send an array of
	-- items and we need to iterate and setup. Once it finishes bulk creating, we fire back
	-- on server, and it will perform next bulk add, and etc etc.
	BulkCreateHouses = route.new(standard) :: Route<{ Model }, { Entity }, { types.BuildingRemoteParams }>,
	IFinishedSettingUpHousesInitiially = route.new(standard) :: Route<>,
	BulkCreateApartments = route.new(standard) :: Route<{ Model }, { Entity }, { types.BuildingRemoteParams }>,
	IFinishedSettingUpAptsInitiially = route.new(standard) :: Route<>,
	BulkCreateRestaurants = route.new(standard) :: Route<{ Model }, { Entity }, { types.BuildingRemoteParams }>,
	IFinishedSettingUpRestaurantInitiially = route.new(standard) :: Route<>,

	CreateHouse = route.new(standard) :: Route<Model, Entity, types.BuildingRemoteParams>,
	CreateApartment = route.new(standard) :: Route<Model, Entity, types.BuildingRemoteParams>,
	CreateRestaurant = route.new(standard) :: Route<Model, Entity, types.BuildingRemoteParams>,
	DeleteHouse = route.new(standard) :: Route<Entity>,
	DeleteApartment = route.new(standard) :: Route<Entity>,
	DeleteRestaurant = route.new(standard) :: Route<Entity>,

	IWantToTeleportInOrOut = route.new(standard) :: Route<Model>,
}
