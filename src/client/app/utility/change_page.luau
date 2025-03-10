local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ui_pages = require(ReplicatedStorage.client.app.ui_store.ui_pages)
local ui_store = require(ReplicatedStorage.client.app.ui_store)

local function change_page(page: string)
	local found = false
	for i, page_name in ui_pages do
		if page_name == page then
			found = true
		end
	end

	assert(found, `Attempted to navigate to unknown page {page}`)

	local currpage = ui_store.page
	local lastpage = ui_store.lastpage

	lastpage(currpage())
	currpage(page)
end

return change_page
