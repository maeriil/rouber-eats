local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local components = require(ReplicatedStorage.common.ecs.components)
local dialogue_frame = require(ReplicatedStorage.client.app.components.dialogue.dialogue_frame)
local dialogue_start = require(ReplicatedStorage.client.app.components.dialogue.dialogue_start)
local eventqueue = require(ReplicatedStorage.client.app.ui_store.eventqueue)
local events = require(ReplicatedStorage.common.events)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local iconpresets = require(ReplicatedStorage.client.app.components.icon.iconpresets)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local slight_rounded = require(ReplicatedStorage.client.app.components.corner.slight_rounded)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local ui_pages = require(ReplicatedStorage.client.app.ui_store.ui_pages)
local ui_store = require(ReplicatedStorage.client.app.ui_store)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local world = require(ReplicatedStorage.common.ecs.world)

local source = vide.source
type Source<T> = vide.Source<T>
type can<T> = T | () -> T
local show = vide.show
local px = use_px.px
local values = vide.values
local create = vide.create

local base_header_height = 96
local header_max_height = 96
local header_min_height = 52

type buttonprops = {
	name: string,
	desc: string,
	page_name: string,
}

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

local function create_icon(props: buttonprops, page: Source<string>, order: number)
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
		size = UDim2.new(1, 0, 1, 0),
		anchor = Vector2.new(0.5, 0.5),
		square {},
		circle {},

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

local function home_page(props: {
	page: Source<string>,
})
	local selected = source(nil :: types.Entity?)
	local header_size = function()
		local read_height = px(base_header_height)
		local clamped = math.clamp(read_height, header_min_height, header_max_height)
		return UDim2.new(1, 0, 0, clamped)
	end
	local order = next_order()
	local buttons: { buttonprops } = {
		{ name = "home", desc = "Home page", page_name = ui_pages.PhoneHome },
		{ name = "shop", desc = "Shop Menu", page_name = ui_pages.Shop },
		{ name = "delivery", desc = "Rouber Delivery", page_name = ui_pages.Delivery },
	}
	local headerbuttons = {}

	for i, buttonprops in buttons do
		table.insert(headerbuttons, create_icon(buttonprops, props.page, order()))
	end

	return pane {
		size = UDim2.new(1, 0, 1, 0),
		padding {
			y = function()
				return UDim.new(0, px(8))
			end,
			x = function()
				return UDim.new()
			end,
		},
		pane {
			size = header_size,
			hlayout {
				halign = Enum.HorizontalAlignment.Right,
				pad = function()
					return UDim.new(0, px(16))
				end,
			},
			padding {
				y = function()
					return UDim.new(0, px(4))
				end,
				x = function()
					return UDim.new(0, px(100))
				end,
			},

			headerbuttons,
		},
		frame {
			size = function()
				return UDim2.new(0, px(400), 0, px(400))
			end,
			pos = function()
				return UDim2.new(1, -px(32), 1, -px(32))
			end,
			anchor = Vector2.new(1, 1),

			vlayout {},
			pane {
				order = 1,
				size = UDim2.new(1, 0, 1, 0),
				flexfill {},
				vlayout {},
				values(ui_store.DeliveryOrderList, function(entity, _)
					local e = entity
					local details = world:get(e, components.DeliveryOrderDetails)
					assert(details ~= nil, "Details cannot be nil")
					local food_concated = table.concat(details.items, ",")

					return frame {
						order = 1,
						color = Color3.fromRGB(0, 100, 200),
						size = function()
							return UDim2.new(1, 0, 0, px(48))
						end,
						basebutton {
							click = function()
								selected(e)
							end,
						},
						par {
							text = text_sizes.bolded(food_concated),
							size = function()
								return px(28)
							end,
						},
					}
				end),
			},
			show(function()
				return selected() ~= nil
			end, function()
				return frame {
					color = Color3.fromRGB(0, 255, 0),
					order = 2,
					size = function()
						return UDim2.new(1, 0, 0, px(32))
					end,
					basebutton {
						click = function()
							-- Etiher fire to server from here, or pass to ecs and ecs will fire + some other thing?
							-- mayeb small kind of particle effectr whihc we might add later
							local id = selected()
							if id ~= nil then
								print("accepting the order with clientid ", selected())
								local server_id = world:get(id, components.EntityId) :: types.Entity
								print("the server id is ", server_id)
								events.IWantToAcceptOrderRequest:send(server_id)
							end
						end,
					},
					par {
						text = "Accept",
						size = function()
							return px(28)
						end,
					},
				}
			end),
		},
	}
end

return home_page
