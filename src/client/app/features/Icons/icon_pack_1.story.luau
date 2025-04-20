-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hlayout           = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local AchievementsIcon  = require(ReplicatedStorage.client.app.features.Icons.AchievementsIcon)
local BackpackIcon      = require(ReplicatedStorage.client.app.features.Icons.BackpackIcon)
local ChatIcon          = require(ReplicatedStorage.client.app.features.Icons.ChatIcon)
local CompanionIcon     = require(ReplicatedStorage.client.app.features.Icons.CompanionIcon)
local DoorIcon          = require(ReplicatedStorage.client.app.features.Icons.DoorIcon)
local HomeIcon          = require(ReplicatedStorage.client.app.features.Icons.HomeIcon)
local JournalIcon       = require(ReplicatedStorage.client.app.features.Icons.JournalIcon)
local MagnifyIcon       = require(ReplicatedStorage.client.app.features.Icons.MagnifyIcon)
local OrdersIcon        = require(ReplicatedStorage.client.app.features.Icons.OrdersIcon)
local ReputationIcon    = require(ReplicatedStorage.client.app.features.Icons.ReputationIcon)
local RoubinsIcon       = require(ReplicatedStorage.client.app.features.Icons.RoubinsIcon)
local ShopIcon          = require(ReplicatedStorage.client.app.features.Icons.ShopIcon)
local Star8Icon         = require(ReplicatedStorage.client.app.features.Icons.Star8Icon)
local TouchInterestIcon = require(ReplicatedStorage.client.app.features.Icons.TouchInterestIcon)
local TutorialIcon      = require(ReplicatedStorage.client.app.features.Icons.TutorialIcon)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local next_order        = require(ReplicatedStorage.common.utility.next_order)
local vide              = require(ReplicatedStorage.pkg.vide)

local mount             = vide.mount
local px                = use_px.px
-- stylua: ignore end

local function story()
	use_px.use_px()
	local iconsize = function()
		return UDim2.new(0, px(256), 0, px(256))
	end

	local order = next_order()

	return frame {
		color = Color3.fromRGB(0, 100, 255),

		hlayout {
			wraps = true,
		},
		pane {
			order = order(),
			size = iconsize,
			OrdersIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			TutorialIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			BackpackIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			CompanionIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			AchievementsIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			JournalIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			ShopIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			ReputationIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			HomeIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			RoubinsIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			TouchInterestIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			DoorIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			Star8Icon {},
		},
		pane {
			order = order(),
			size = iconsize,
			ChatIcon {},
		},
		pane {
			order = order(),
			size = iconsize,
			MagnifyIcon {},
		},
	}
end

return function(target)
	return mount(story, target)
end
