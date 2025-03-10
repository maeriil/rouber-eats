--[[
    The template for how we save players data in the data store.

    Initially when we get data from our data store, it will be in this format.
    The next step would be to turn these data into the components / playerstore format
]]

local template = {
	coins = 0,
	gems = 0,
}
export type template = typeof(template)

local store = {} :: { [Player]: template }

return store
