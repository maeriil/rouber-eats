local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)

local function change_page(page: types.GamePages)
	local currpage = uistore.page
	local lastpage = uistore.lastpage

	lastpage(currpage())
	currpage(page)
end

return change_page
