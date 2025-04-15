-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vlayout     = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local pane        = require(ReplicatedStorage.client.app.components.pane.pane)
local EnterAction = require(ReplicatedStorage.client.app.features.Graffiti.Presets.EnterAction)
local cleared     = require(ReplicatedStorage.client.app.features.Graffiti.Presets.cleared)
local gained      = require(ReplicatedStorage.client.app.features.Graffiti.Presets.gained)
local use_px      = require(ReplicatedStorage.client.app.utility.use_px)
local next_order  = require(ReplicatedStorage.common.utility.next_order)
local vide        = require(ReplicatedStorage.pkg.vide)

local mount       = vide.mount
local px          = use_px.px
-- stylua: ignore end

local function story()
	use_px.use_px()
	local order = next_order()
	local size = function()
		return UDim2.new(0, px(300), 0, px(96))
	end

	return pane {
		vlayout {},
		pane {
			order = order(),
			EnterAction {},
			size = size,
		},
		pane {
			order = order(),
			gained {},
			size = size,
		},
		pane {
			order = order(),
			cleared {},
			size = size,
		},
	}
end

return function(target)
	return mount(story, target)
end
