-- stylua: ignore start
local ReplicatedStorage      = game:GetService("ReplicatedStorage")

local assets                 = require(ReplicatedStorage.assets.assets)
local baseimage              = require(ReplicatedStorage.client.app.components.image.baseimage)
local hlayout                = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local frame                  = require(ReplicatedStorage.client.app.components.pane.frame)
local pane                   = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext                  = require(ReplicatedStorage.client.app.components.text.rtext)
local gained                 = require(ReplicatedStorage.client.app.features.Graffiti.Presets.gained)
local sp_graffiti            = require(ReplicatedStorage.client.app.features.Graffiti.sp_graffiti)
local translate_number_async = require(ReplicatedStorage.client.app.utility.translate_number_async)
local use_px                 = require(ReplicatedStorage.client.app.utility.use_px)
local colorscheme = require(ReplicatedStorage.client.store.colorscheme)
local vide                   = require(ReplicatedStorage.pkg.vide)

local source                 = vide.source
local px                     = use_px.px
-- stylua: ignore end

type props = {
	money: () -> number,
}

local function money_graffiti_text(props)
	local text = "Money"
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
					secondar_color = colorscheme.blood_red,
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

local function result_money(props: props): { any }
	local img = assets.images["HoverEffect1.svg"]
	local img_rect_offset = function()
		return Vector2.new(512, 128 * 7)
	end
	local img_rect_size = function()
		return Vector2.new(512, 128)
	end
	local function anchor_center()
		return Vector2.new(0.5, 0.5)
	end
	local function pos_center()
		return UDim2.new(0.5, 0, 0.5, 0)
	end

	local my_number = source(tostring(props.money()))

	task.spawn(function()
		-- This is an async operation so it could halt the thread which is why we use it on
		-- seperate task and use a source to update it.

		local result = translate_number_async(props.money())
		my_number(result)
	end)

	return {
		pane {
			size = function()
				return UDim2.new(0.8, 0, 0.3, 0)
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
					return UDim2.new(0.5, 0, 1, 0)
				end,
				anchor = Vector2.new(0.5, 1),
				color = Color3.fromRGB(255, 0, 0),
			},
			pane {
				pos = function()
					return UDim2.new(0, 0, 1, px(4))
				end,
				anchor = Vector2.new(0, 1),
				rotation = -2,
				money_graffiti_text {},
			},
		},
		pane {
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
						anchor = anchor_center,
						pos = pos_center,
						rtext {
							text = function()
								return `{my_number()}`
							end,
							xbolded = true,
							italic = true,
							size = "md",
							color = function()
								return Color3.fromRGB(255, 255, 255)
							end,
							xalign = Enum.TextXAlignment.Right,
						},
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
			gained {},
		},
	}
end

return result_money
