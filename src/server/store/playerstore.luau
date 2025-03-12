local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- We want to use this whenever possible rather than adding too many components
-- to the player's entity
-- especially if its something that needs to be updated frequently since archetype ecs
-- greatest weakness is constant updates

local types = require(ReplicatedStorage.types)
type Entity = types.Entity

export type PlayerDetails = {
	-- Boolean value indicating whether their client world has been setup with
	-- house, should do the same for restaurants, and any types of buildings we may add
	has_setup_house: boolean,
	sent_req_to_setup_house: boolean,
	has_setup_restaurant: boolean,
	sent_req_to_setup_restaurant: boolean,
	has_setup_apartments: boolean,
	sent_req_to_setup_apartments: boolean,

	-- Players can have only one residence, so this entity points to the residence they own
	residence: Entity,

	-- Players can however increase from Apt, to House, and etc, basically they can unlock
	-- higher tier. In this case, we include a boolean of things they have unlocked and instead
	-- mark it to determine what kind of building to allocate for them in future
	unlocked_house: boolean,
	unlocked_mansion: boolean,

	has_sent_existing_world_order: boolean,

	active_orders: { types.Entity },
}

local store: {
	[Player]: PlayerDetails,
} = {}

return store
