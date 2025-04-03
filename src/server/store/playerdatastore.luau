local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
--[[
    The template for how we save players data in the data store.

    Initially when we get data from our data store, it will be in this format.
    The next step would be to turn these data into the components / playerstore format
]]

local template = {
	coins = 0,
	gems = 0,
	housetype = "House_BasicHouse" :: types.BuildingsType,
	orderpity = 0,
	rating = 0.0,
	total_orders_delivered = 0,
	total_orders_stolen = 0,
	total_orders_altered = 0,
}
export type template = typeof(template)

local store = {} :: { [Player]: template }

return store
