local c = require(script.Parent.components)
local world = require(script.Parent.world)

return {
	get_houses = world:query(c.Model):with(c.House):cached(),
	get_restaurants = world:query(c.Model):with(c.Restaurant):cached(),
	get_apartments = world:query(c.Model):with(c.Apartment):cached(),

	-- For deleteing instances from server
	iterate_cleanup = world:query(c.EntityId, c.Cleanup):cached(),

	all_client = world:query(c.Client):cached(),
}
