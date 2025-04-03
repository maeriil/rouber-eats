local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local basefont = require(ReplicatedStorage.common.configs.gamefont.basefont)
local border = require(ReplicatedStorage.client.app.components.border.border)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local px = use_px.px
local create = vide.create
local read = vide.read
local show = vide.show

local function Header(props: {
	text: types.Can<string>,
	italic: boolean?,
	xalign: Enum.TextXAlignment?,
	yalign: Enum.TextYAlignment?,
	pos: types.Can<UDim2>?,
	color: types.Can<Color3>?,
	size: "medium" | "large"?,
})
	local text = function()
		local src = read(props.text)

		if props.italic then
			src = `<i>{src}</i>`
		end
		src = `<b>{src}</b>`

		return src
	end

	local sz = function()
		if not props.size then
			return px(64)
		end

		if props.size == "medium" then
			return px(48)
		end
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

local function TextPar(props: {
	text: types.Can<string>,
	italic: boolean?,
	color: types.Can<Color3>?,
	xalign: Enum.TextXAlignment?,
	yalign: Enum.TextYAlignment?,
})
	local text = function()
		local src = read(props.text)

		if props.italic then
			src = `<i>{src}</i>`
		end
		src = `<b>{src}</b>`

		return src
	end
	local base_font = basefont.font

	return create "TextLabel" {
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		RichText = true,
		Text = text,
		TextSize = function()
			return px(28)
		end,
		TextColor3 = props.color or Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		FontFace = base_font,
		TextWrapped = true,
		TextXAlignment = props.xalign or Enum.TextXAlignment.Center,
		TextYAlignment = props.yalign or Enum.TextYAlignment.Center,
	}
end

local function Star(props: {
	order: types.Can<number>?,
	color: types.Can<Color3>?,
})
	return pane {
		size = UDim2.new(1, 0, 0.35, 0),
		square {},
		order = props.order,
		create "ImageLabel" {
			Size = UDim2.new(1, 0, 1, 0),
			Image = assets.images["ActiveStar.svg"],
			ImageColor3 = props.color or Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Rotation = 30,
		},
	}
end

local function Rating(props: {
	star: types.Can<number>,
})
	local list = {}

	for i = 1, read(props.star) do
		local st = Star {
			order = i,
			color = Color3.fromRGB(0, 0, 0),
		}
		table.insert(list, st)
	end
	return {
		hlayout {
			halign = Enum.HorizontalAlignment.Right,
		},
		padding {
			y = padding_types.nopad,
			x = padding_types.px8,
		},
		list,
	} :: { any }
end

type props = {
	content: types.Can<types.DeliveryOrderType>,
	active: types.Can<boolean>,
	click: () -> (),
}

local function RouberOrderCard(props: props)
	local order = next_order()
	local left_right_gap = 72
	local muted_red = Color3.fromHex("#555550")
	local faded = Color3.fromHex("#333333")
	local foreground = function()
		return if read(props.active) then Color3.fromHex("#111111") else Color3.fromHex("#FFFFFF")
	end
	local red = Color3.fromHex("#D92323")
	local white = Color3.fromHex("#FFFFFF")
	local on_active_src = function()
		return read(props.active)
	end

	return frame {
		color = foreground,
		size = function()
			return UDim2.new(1, 0, 0, px(180))
		end,
		basebutton {
			click = function()
				props.click()
			end,
		},
		show(on_active_src, function()
			return frame {
				size = UDim2.new(1, -px(left_right_gap) * 2, 0.4, 0),
				color = red,
				anchor = Vector2.new(0.5, 1),
				pos = UDim2.new(0.5, 0, 1, 0),
			}
		end),

		pane {
			zindex = 3,
			hlayout {
				pad = padding_types.px16,
			},
			size = UDim2.new(1, 0, 1, 0),
			pane {
				size = UDim2.new(0, px(84), 1, 0),
				frame {
					color = muted_red,
					size = UDim2.new(0.8, 0, 0.65, 0),
					rotation = -15,
					border {
						thickness = px(8),
						color = faded,
					},
				},
			},
			pane {
				size = UDim2.new(1, 0, 1, 0),
				vlayout {},
				flexfill {},
				pane {
					name = "top",
					order = order(),
					size = function()
						return UDim2.new(1, 0, 0.6, 0)
					end,
					hlayout {},
					pane {
						order = order(),
						flexfill {},
						size = function()
							return UDim2.new(0.5, 0, 1, 0)
						end,
						Header {
							text = function()
								local content = read(props.content) :: types.DeliveryOrderType
								return `{content.restaurant_name}`
							end,
							italic = true,
							xalign = Enum.TextXAlignment.Left,
							color = function()
								return if read(props.active) then white else faded
							end,
							size = "medium",
						},
					},
					pane {
						order = order(),
						flexfill {},
						size = function()
							return UDim2.new(0.5, 0, 1, 0)
						end,
						Header {
							text = function()
								local content = read(props.content) :: types.DeliveryOrderType
								return `C {content.reward_amount}`
							end,
							italic = false,
							xalign = Enum.TextXAlignment.Right,
							yalign = Enum.TextYAlignment.Bottom,
							pos = function()
								return UDim2.fromOffset(-px(8), px(14))
							end,
							color = function()
								return if read(props.active) then red else faded
							end,
						},
					},
					pane {
						size = function()
							return UDim2.new(0, px(left_right_gap), 1, 0)
						end,
						order = order(),
					},
				},
				pane {
					name = "bottom",
					order = order(),
					size = function()
						return UDim2.new(1, 0, 0.4, 0)
					end,
					hlayout {},
					pane {
						order = order(),
						name = "left",
						size = UDim2.new(0.5, 0, 1, 0),
						flexfill {},
						hlayout {
							valign = Enum.VerticalAlignment.Bottom,
						},
						frame {
							size = UDim2.new(1, 0, 0.9, 0),
							square {},
							color = faded,
							create "ImageLabel" {
								Image = function()
									local content = read(props.content) :: types.DeliveryOrderType
									local food_one = content.foods_list[1].image

									return food_one
								end,
								BackgroundTransparency = 1,
								Size = function()
									return UDim2.new(0.75, 0, 0.75, 0)
								end,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0),
							},
						},
					},
					pane {
						order = order(),
						name = "right-rating",
						size = UDim2.new(0.5, 0, 1, 0),
						Rating {
							star = function()
								local content = read(props.content) :: types.DeliveryOrderType
								return content.order_rating
							end,
						},
						flexfill {},
					},
					pane {
						size = function()
							return UDim2.new(0, px(left_right_gap), 1, 0)
						end,
						order = order(),
					},
				},
			},
		},
		frame {
			color = faded,
			size = UDim2.new(0.75, 0, 0, 5),
			pos = UDim2.new(0.5, 0, 1, px(16)),
			anchor = Vector2.new(0.5, 0.5),
		},
	}
end

return RouberOrderCard
