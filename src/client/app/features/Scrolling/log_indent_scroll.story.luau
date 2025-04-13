local ReplicatedStorage = game:GetService("ReplicatedStorage")

local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local log_indent_scroll = require(ReplicatedStorage.client.app.features.Scrolling.log_indent_scroll)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)

local mount = vide.mount
local source = vide.source
local px = use_px.px

type content_type = {
	icon: string,
	text: string,
	rating: number,
}

local function story()
	use_px.use_px()
	local content = source {
		{ icon = "somrthing", text = "hehe", rating = 4.0 },
		{ icon = "", text = "zamina", rating = 4.2 },
		{ icon = "", text = "cocobop", rating = 4.3 },
		{ icon = "", text = "shimishimi", rating = 4.5 },
		{ icon = "somrthing", text = "hehe", rating = 4.0 },
		{ icon = "", text = "zamina", rating = 4.2 },
		{ icon = "", text = "cocobop", rating = 4.3 },
		{ icon = "", text = "shimishimi", rating = 4.5 },
	} :: types.Source<types.Array<content_type>>
	local selected = source(1)

	return frame {
		color = Color3.fromRGB(255, 0, 0),
		frame {
			size = function()
				return UDim2.new(0, px(600), 1, 0)
			end,
			anchor = Vector2.new(0.5, 0.5),
			pos = UDim2.fromScale(0.5, 0.5),
			padding {
				y = padding_types.px32,
				x = padding_types.px8,
			},
			log_indent_scroll {
				content = content,
				click = selected,
				active_idx = selected,
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
