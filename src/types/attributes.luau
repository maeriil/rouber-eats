return {
	-- Add any other attributes that we need here

	serverid = "server_id",
	clientid = "client_id",
	-- This is the config name of the restuarant that the server will assign on the games startup
	restaurant_name_id = "restaurant_name_id",

	-- When a new player or npc is created by the server, it will create the house related stuff
	-- alongside. residence_id will only exists on the HouseOwner models and this is the server id
	-- of their parent house
	residence_id = "residence_id",
}
