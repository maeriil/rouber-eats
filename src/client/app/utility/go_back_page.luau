local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uistore = require(ReplicatedStorage.client.app.uistore)

local function go_back_page()
	local currpage = uistore.page
	local lastpage = uistore.lastpage

	currpage(lastpage())
	lastpage("HudScreen")
end

return go_back_page
