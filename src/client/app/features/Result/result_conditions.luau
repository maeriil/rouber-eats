-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local flexfill          = require(ReplicatedStorage.client.app.components.flex.flexfill)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local hlayout           = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local vlayout           = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local square            = require(ReplicatedStorage.client.app.components.ratio.square)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local cleared           = require(ReplicatedStorage.client.app.features.Graffiti.Presets.cleared)
local sp_graffiti       = require(ReplicatedStorage.client.app.features.Graffiti.sp_graffiti)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)
local types             = require(ReplicatedStorage.types)

local px                = use_px.px
local show              = vide.show
-- stylua: ignore end

--[[
  TODO: Create a checkmark component, we use X right now and that might be confusing lmao
]]
local function checkmark(props)
	local image_id = assets.images["ActiveStar.svg"]

	return baseimage {
		img = image_id,
	}
end

local function money_graffiti_text(props)
	local text = "COnDitions"
	local letters = {}

	for i = 1, #text do
		local curr_letter = text:sub(i, i)
		table.insert(
			letters,
			pane {
				size = function()
					return UDim2.new(0, px(48), 1, 0)
				end,
				sp_graffiti {
					letter = function()
						return curr_letter
					end,
					secondar_color = Color3.fromRGB(255, 0, 0),
					primary_color = Color3.fromRGB(),
					order = function()
						return i
					end,
					thickness = function()
						return px(8)
					end,
					italic = false,
					-- transparency = props.transparency,
					-- stransparency = props.transparency,
				},
			}
		)
	end

	return pane {
		hlayout {},
		letters,
	}
end

local function render_condition(props: {
	text: string,
	success: boolean,
	order: number,
})
	local pos_cen = function()
		return UDim2.new(0.5, 0, 0.5, 0)
	end
	local anchor_cen = function()
		return Vector2.new(0.5, 0.5)
	end
	local function textcolor()
		return Color3.fromRGB(255, 255, 255)
	end
	local function show_checkmark()
		return props.success
	end

	return pane {
		hlayout {},
		order = props.order,
		size = function()
			return UDim2.new(1, 0, 0, px(52))
		end,
		pane {
			size = function()
				return UDim2.new(0.15, 0, 1, 0)
			end,
			frame {
				size = function()
					return UDim2.new(1, 0, 0.9, 0)
				end,
				square {},
				pos = pos_cen,
				anchor = anchor_cen,
				color = Color3.fromRGB(100, 100, 100),
				frame {
					size = function()
						return UDim2.new(0.65, 0, 0.65, 0)
					end,
					pos = pos_cen,
					anchor = anchor_cen,
					color = Color3.fromRGB(),
				},
			},
			show(show_checkmark, function()
				return pane {
					anchor = anchor_cen,
					pos = pos_cen,
					square {},
					checkmark {},
				}
			end),
		},
		pane {
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			rtext {
				text = function()
					return props.text
				end,
				xalign = Enum.TextXAlignment.Left,
				bolded = true,
				italic = true,
				color = textcolor,
			},
			flexfill {},
		},
	}
end

type props = {
	conditions: () -> types.Array<{
		text: string,
		success: boolean,
	}>,
}

local function result_conditions(props: props)
	local img = assets.images["HoverEffect1.svg"]
	local img_rect_offset = function()
		return Vector2.new(512, 128 * 7)
	end
	local img_rect_size = function()
		return Vector2.new(512, 128)
	end

	local check_list = {}

	for i, content in props.conditions() do
		table.insert(
			check_list,
			render_condition {
				text = content.text,
				success = content.success,
				order = i,
			}
		)
	end

	return {
		pane {
			size = function()
				return UDim2.new(0.8, 0, 0.30, 0)
			end,
			pos = function()
				return UDim2.new(0.5, 0, 0, px(48 / 2))
			end,
			anchor = Vector2.new(0.5, 0),
			frame {
				size = function()
					return UDim2.new(0.75, 0, 0, px(48))
				end,
				pos = function()
					return UDim2.new(0.5, 0, 1, -px(48 / 2))
				end,
				anchor = Vector2.new(0.5, 1),
				color = Color3.fromRGB(255, 0, 0),
			},
			pane {
				pos = function()
					return UDim2.new(0, 0, 1, px(8))
				end,
				anchor = Vector2.new(0, 1),
				rotation = -0,
				money_graffiti_text {},
			},
		},
		pane {
			-- color = Color3.fromRGB(0, 255, 255),
			transparency = 0.5,
			pos = function()
				return UDim2.new(0, 0, 0, px(48))
			end,
			baseimage {
				img = img,
				img_rect_size = img_rect_size,
				img_rect_offset = img_rect_offset,
				pane {
					name = "inner-container",
					size = function()
						return UDim2.new(0.9, 0, 0.85, 0)
					end,
					anchor = Vector2.new(0.5, 0),
					pos = function()
						return UDim2.new(0.5, 0, 0, px(4))
					end,
					baseimage {
						img = img,
						img_rect_size = img_rect_size,
						img_rect_offset = img_rect_offset,
						color = function()
							return Color3.fromRGB(0, 0, 0)
						end,
					},

					pane {
						size = function()
							return UDim2.new(0.85, 0, 0.85, 0)
						end,
						anchor = function()
							return Vector2.new(0.5, 0.5)
						end,
						pos = function()
							return UDim2.new(0.5, 0, 0.5, 0)
						end,
						vlayout {
							pad = padding_types.px8,
							valign = Enum.VerticalAlignment.Center,
						},
						check_list,
						-- rtext {
						-- 	text = function()
						-- 		return `{my_number()}`
						-- 	end,
						-- 	xbolded = true,
						-- 	italic = true,
						-- 	size = "md",
						-- 	color = function()
						-- 		return Color3.fromRGB(255, 255, 255)
						-- 	end,
						-- 	xalign = Enum.TextXAlignment.Right,
						-- },
					},
				},
			},
		},

		pane {
			size = function()
				return UDim2.new(0, px(300), 0, px(96))
			end,
			pos = function()
				return UDim2.new(1, -px(32), 1, -px(32))
			end,
			anchor = function()
				return Vector2.new(0.5, 0.5)
			end,
			cleared {},
		},
	}
end

return result_conditions
