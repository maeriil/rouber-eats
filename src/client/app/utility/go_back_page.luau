local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ui_pages = require(ReplicatedStorage.client.app.ui_store.ui_pages)
local ui_store = require(ReplicatedStorage.client.app.ui_store)

local function go_back_page()
	print("going back to old page")
	local currpage = ui_store.page
	local lastpage = ui_store.lastpage

	currpage(lastpage())

	-- This is mostly for safety precaution since i havent finalized what a home page means
	local page = ui_pages.Game
	local found = false
	for i, page_name in ui_pages do
		if page_name == page then
			found = true
		end
	end

	assert(found, `Attempted to navigate to unknown page {page}`)

	lastpage(ui_pages.Game)
end

return go_back_page
