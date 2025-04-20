-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local hlayout           = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local sp_graffiti       = require(ReplicatedStorage.client.app.features.Graffiti.sp_graffiti)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local colorscheme = require(ReplicatedStorage.client.store.colorscheme)
local basefont          = require(ReplicatedStorage.common.configs.gamefont.basefont)

local px                = use_px.px

type props = {
  currlevel : () -> number,
  currexp   : () -> number,
  maxexp    : () -> number,
}

-- stylua: ignore end

local function exp_graffiti_text(props)
	local text = "EXP"
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

local function progress_bar(props: {
	percent: () -> number,
	primary_color: Color3,
	secondary_color: Color3,
})
	return frame {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		color = props.secondary_color,
		frame {
			size = function()
				return UDim2.new(props.percent(), 0, 1, 0)
			end,
			color = props.primary_color,
		},
	}
end

local function result_exp(props: props)
	local img = assets.images["HoverEffect1.svg"]
	local img_rect_offset = function()
		return Vector2.new(512, 128 * 7)
	end
	local img_rect_size = function()
		return Vector2.new(512, 128)
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
					return UDim2.new(0.5, 0, 1, -0)
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
				exp_graffiti_text {},
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
						anchor = function()
							return Vector2.new(0.5, 0)
						end,
						pos = function()
							return UDim2.new(0.5, 0, 0, 0)
						end,
						rtext {
							text = function()
								return `<font size="{basefont.sizes.small}">Lvl</font> {props.currlevel()}`
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

					pane {
						size = function()
							return UDim2.new(0.85, 0, 0.05, 0)
						end,
						anchor = function()
							return Vector2.new(0.5, 0.5)
						end,
						pos = function()
							return UDim2.new(0.5, 0, 0.5, px(32))
						end,
						progress_bar {
							percent = function()
								return props.currexp() / props.maxexp()
							end,
							primary_color = Color3.fromRGB(255, 0, 0),
							secondary_color = Color3.fromRGB(255, 255, 255),
						},
					},
				},
			},
		},
	}
end

return result_exp
