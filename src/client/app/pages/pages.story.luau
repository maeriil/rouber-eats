local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local gamepage = require(script.Parent.gamepage)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local phonehomepage = require(script.Parent.phonehomepage)
local ui_pages = require(ReplicatedStorage.client.app.ui_store.ui_pages)
local ui_store = require(ReplicatedStorage.client.app.ui_store)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local source = vide.source
local switch = vide.switch
local create = vide.create
local px = use_px.px

local function story()
	use_px.use_px()
	local page = ui_store.page
	local function change_page() end

	return switch(page) {
		[""] = function()
			return frame {
				size = UDim2.new(1, 0, 1, 0),
				create "TextLabel" {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					TextSize = 96,
					Text = "Unkown page is shown",
				},
			}
		end,
		[ui_pages.Game] = function()
			return gamepage {
				page = page,
				change_page = change_page,
				go_back_page = go_back_page,
			}
		end,
		[ui_pages.PhoneHome] = function()
			return phonehomepage {
				page = page,
			}
		end,
	}
end

return function(target)
	return mount(story, target)
end
