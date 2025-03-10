local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local iconpresets = require(ReplicatedStorage.client.app.components.icon.iconpresets)
local padding = require(ReplicatedStorage.client.app.components.padding)
local par = require(ReplicatedStorage.client.app.components.label.par)
local phone_header = require(ReplicatedStorage.client.app.features.Phone.presets.phone_header)
local portrait = require(ReplicatedStorage.client.app.features.Phone.layouts.portrait)
local slight_rounded = require(ReplicatedStorage.client.app.components.corner.slight_rounded)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local ui_pages = require(ReplicatedStorage.client.app.ui_store.ui_pages)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type Source<T> = vide.Source<T>
type can<T> = T | () -> T
local source = vide.source
local indexes = vide.indexes
local px = use_px.px
local action = vide.action
local cleanup = vide.cleanup
local show = vide.show

local function phone_footer() end

type buttonprops = {
	name: string,
	desc: string,
	page_name: string,
}

--//TODO We should turn this into a component
warn(`iconhover should be turned into a component`)
local function iconhover(props: {
	content: can<string>,
})
	return frame {
		size = UDim2.new(0, px(96), 0, px(30)),
		anchor = Vector2.new(0.5, 0),
		zindex = 10,
		pos = function()
			return UDim2.new(0.5, 0, 1, 5)
		end,
		par {
			text = props.content,
			wrap = true,
			xalign = Enum.TextXAlignment.Center,
		},
		slight_rounded {},
	}
end

--//TODO We should turn this into a component
warn(`icon component should be turn into a component`)
local function create_icon(
	props: buttonprops,
	page: Source<string>,
	order: number,
	size: can<UDim2>
)
	local icon_comp = iconpresets[props.name]
	local hovering = source(false)
	local hoverenter = function()
		hovering(true)
	end
	local hoverleave = function()
		hovering(false)
	end

	return frame {
		color = Color3.fromRGB(200, 150, 100),
		order = order,
		size = size,
		anchor = Vector2.new(0.5, 0.5),
		square {},
		slight_rounded {},

		show(hovering, function()
			return iconhover {
				content = props.desc,
			}
		end),

		basebutton {
			hoverenter = hoverenter,
			hoverleave = hoverleave,
			click = function()
				change_page(props.page_name)
			end,
			padding {
				padding = function()
					return UDim.new(0, px(10))
				end,
			},
			icon_comp {},
		},
	}
end

local function phone_homepage(props: {
	page: Source<string>,
})
	-- Should be portrait layout
	local owned_buttons = source({
		{ name = "shop", page_name = ui_pages.Shop, desc = "Open Shop Page" },
		{ name = "delivery", page_name = ui_pages.Delivery, desc = "Open RoDeliveries" },
		{ name = "inventory", page_name = ui_pages.Delivery, desc = "Open Inventory" },
		{ name = "tutorial", page_name = ui_pages.Delivery, desc = "View Tutorials" },
		{ name = "achievements", page_name = ui_pages.Delivery, desc = "View Achievements" },
		{ name = "settings", page_name = ui_pages.Delivery, desc = "View Settings" },
	})

	local space_pad = source(px(16))
	local base_offset = function()
		return UDim.new(0, px(16))
	end
	local icon_size = function()
		local x = math.clamp(px(96), 48, 96)
		local y = math.clamp(px(96), 48, 96)

		return UDim2.new(0, x, 0, y)
	end

	return portrait {
		header = phone_header,
		footer = phone_footer,
		exit = function()
			go_back_page()
		end,

		-- Similar to grid layout, we add icons of the buttons with Max/min sizes so we can
		-- set Wraps to true
		padding {
			x = base_offset,
			y = base_offset,
		},

		action(function(frame: Frame)
			cleanup(frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function(...: any)
				local i_size = icon_size()
				local outside_pad = base_offset().Offset
				local x = i_size.X.Offset

				local abs_size = frame.AbsoluteSize
				local min_gap = px(16)
				local abs_x = abs_size.X - outside_pad * 2
				local max_items = abs_x // x
				local min_pad = (max_items - 1) * min_gap

				local final_items = (abs_x - min_pad) // x
				local rem_pad = (abs_x - (final_items * x)) // (final_items - 1)

				space_pad(rem_pad)
			end))
		end),

		hlayout {
			pad = function()
				return UDim.new(0, space_pad())
			end,
			wraps = true,
			valign = Enum.VerticalAlignment.Top,
			hflex = Enum.UIFlexAlignment.None,
			halign = Enum.HorizontalAlignment.Left,
		},

		indexes(
			owned_buttons,
			function(p: () -> { desc: string, name: string, page_name: string }, order: number)
				print(p)
				return create_icon(p(), props.page, order, icon_size)
			end
		),
	}
end

return phone_homepage
