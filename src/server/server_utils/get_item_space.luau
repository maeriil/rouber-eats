local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local gamedata = require(ServerScriptService.server.store.gamedata)

local t = require(ReplicatedStorage.types)

local function determine_space(item_id: t.Entity, count: number)
	-- In future, some items would take more space than others
	--//TODO: item details should contain something liek how much space 1 item takes
	local item_details = gamedata.item_map[item_id]

	return 1 * count
end

return determine_space
