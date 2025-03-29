local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local basefont = require(ReplicatedStorage.common.configs.gamefont.basefont)
local effect1 = require(ReplicatedStorage.client.app.features.ActiveEffect.effect1)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local show = vide.show
local source = vide.source
local create = vide.create
local derive = vide.derive
local read = vide.read
local values = vide.values
local px = use_px.px

type props = {
	details: types.Source<types.DeliveryOrderType>,
	acceptclick: () -> (),
	showaccept: types.Source<boolean>,
}

local function AcceptButton(props: {
	click: () -> (),
	order: types.Can<number>,
})
	--[[
  TODO Make this better..
  ]]

	local hovering = source(false)

	return frame {
		color = Color3.fromRGB(0, 255, 0),
		size = function()
			return UDim2.new(1, 0, 0, px(64))
		end,
		order = props.order,

		basebutton {
			click = props.click,
			hoverenter = function()
				hovering(true)
			end,
			hoverleave = function()
				hovering(false)
			end,
		},
		effect1 {
			color = function()
				return if hovering() then Color3.fromHex("#23d9d9") else Color3.fromHex("#D92323")
			end,
		},
		pane {
			size = UDim2.new(1, 0, 1, 0),
			padding {
				padding = padding_types.px16,
			},
			par {
				text = "Accept",
				size = function()
					return px(text_sizes.heading.h2)
				end,
				xalign = Enum.TextXAlignment.Center,
			},
		},
	}
end

--//TODO: I YOINKED THIS FROM RouberOrderCard file
local function Header(props: {
	text: types.Can<string>,
	italic: boolean?,
	xalign: Enum.TextXAlignment?,
	yalign: Enum.TextYAlignment?,
	pos: types.Can<UDim2>?,
	color: types.Can<Color3>?,
	sz: types.Can<number>?,
})
	local text = function()
		local src = read(props.text)

		if props.italic then
			src = `<i>{src}</i>`
		end
		src = `<b>{src}</b>`

		return src
	end

	local sz = props.sz or function()
		return px(64)
	end

	local base_font = basefont.font
	return create "TextLabel" {
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		Position = props.pos or UDim2.new(),
		RichText = true,
		Text = text,
		TextSize = sz,
		TextColor3 = props.color or Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		FontFace = base_font,
		TextWrapped = true,
		TextXAlignment = props.xalign or Enum.TextXAlignment.Center,
		TextYAlignment = props.yalign or Enum.TextYAlignment.Center,
	}
end

local function FoodsPage(props: {
	foods: types.Source<{ types.DeliveryOrderFoodType }>,
})
	local order = next_order()

	return {
		create "UIPageLayout" {
			Animated = true,
			Circular = true,
			--//TODO: add the easing style nad direction, we should do this when we make a global styles
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
		values(props.foods, function(content, num)
			-- local data = content()
			local data = content
			return frame {
				order = order(),
				size = UDim2.new(1, 0, 1, 0),
				hlayout {},
				frame {
					size = UDim2.fromScale(0.5, 1),
					order = order(),
					create "ImageLabel" {
						Image = function()
							return data.image
						end,
						Size = UDim2.new(1, 0, 0.75, 0),
						BackgroundTransparency = 1,
					},
					square {},
				},
				frame {
					size = UDim2.fromScale(0.5, 1),
					order = order(),
					vlayout {},
					pane {
						color = Color3.fromRGB(0, 255, 255),
						size = UDim2.fromScale(1, 0.5),
						order = order(),
						Header {
							text = function()
								return data.name
							end,
							sz = function()
								return px(22)
							end,
						},
					},
					pane {
						color = Color3.fromRGB(0, 255, 0),
						size = UDim2.fromScale(1, 0.5),
						order = order(),
						Header {
							text = function()
								return `{data.rarity}% Rarity`
							end,
							sz = function()
								return px(22)
							end,
						},
					},
				},
			}
		end),
	} :: { any }
end

local function AddressDetails(props: {
	content: types.Can<{
		restaurant_address: string,
		house_address: string,
	}>,
})
	local order = next_order()

	return {
		vlayout {},
		pane {
			order = order(),
			size = UDim2.new(1, 0, 0.5, 0),
			Header {
				text = function()
					return `* - {read(props.content).restaurant_address}`
				end,
				sz = function()
					return px(28)
				end,
				xalign = Enum.TextXAlignment.Left,
			},
		},
		pane {
			order = order(),
			size = UDim2.new(1, 0, 0.5, 0),
			Header {
				text = function()
					return `* - {read(props.content).house_address}`
				end,
				sz = function()
					return px(28)
				end,
				xalign = Enum.TextXAlignment.Left,
			},
		},
	} :: { any }
end

local function OrderPanelView(props: props)
	local order = next_order()
	local details = derive(props.details)

	return {
		padding {
			y = padding_types.nopad,
			x = padding_types.nopad,
		},
		vlayout {
			pad = padding_types.px8,
		},
		pane {
			color = Color3.fromRGB(180, 50, 50),
			order = order(),
			name = "Restaurant Image container",
			size = function()
				return UDim2.new(1, 0, 0, px(96))
			end,
			create "ImageLabel" {
				Size = UDim2.new(1, 0, 1, 0),
				Image = function()
					return details().restaurant_image or ""
				end,
				BackgroundTransparency = 1,
			},
			flexfill {},
		},
		pane {
			color = Color3.fromRGB(0, 100, 255),
			size = function()
				return UDim2.new(1, 0, 0, px(64))
			end,
			order = order(),
			Header {
				text = function()
					return `C {details().reward_amount}`
				end,
			},
		},
		pane {
			color = Color3.fromRGB(0, 255, 255),
			name = "foods-container",
			order = order(),
			size = function()
				return UDim2.new(1, 0, 0, px(160))
			end,
			FoodsPage {
				foods = function()
					return props.details().foods_list
				end,
			},
		},
		pane {
			color = Color3.fromRGB(0, 255, 0),
			order = order(),
			size = function()
				return UDim2.new(1, 0, 0, px(128))
			end,
			--//TODO: we will need to make this better
			AddressDetails {
				content = function()
					return {
						house_address = details().house_address,
						restaurant_address = details().restaurant_address,
					}
				end,
			},
		},
		show(props.showaccept, function()
			return AcceptButton { click = props.acceptclick, order = order() }
		end),
	} :: { unknown }
end

return OrderPanelView
