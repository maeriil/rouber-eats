local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basefont = require(ReplicatedStorage.common.configs.gamefont.basefont)
local clientgamedata = require(ReplicatedStorage.client.store.clientgamedata)
local close_on_click_outside = require(ReplicatedStorage.client.app.utility.close_on_click_outside)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local throw_error = require(ReplicatedStorage.common.utility.throw_error)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

type props = {}

local indexes = vide.indexes
local values = vide.values
local create = vide.create
local px = use_px.px

type Can<T> = () -> T

local function Card(props: {
	content: Can<string>,
	order: Can<number>,
})
	local foreground = function()
		--//TODO: vide/luau type bug
		-- local order = read(props.order) :: number
		local order = props.order()
		return order % 2 == 0 and Color3.fromRGB() or Color3.fromRGB(255, 255, 255)
	end

	local textcolor = function()
		local order = props.order()
		return order % 2 == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB()
	end

	return frame {
		size = function()
			return UDim2.new(0.85, 0, 0, px(48))
		end,
		color = foreground,
		order = props.order,
		create "TextLabel" {
			BackgroundTransparency = 1,
			FontFace = basefont.font,
			Size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			RichText = true,
			TextColor3 = textcolor,
			Text = props.content,
			TextSize = function()
				return px(32)
			end,
		},
	}
end

local function BackpackScreen(props)
	local order = next_order()
	return frame {
		close_on_click_outside(go_back_page),
		color = Color3.fromRGB(200, 50, 0),
		size = function()
			return UDim2.new(0.85, 0, 0.5, 0)
		end,
		anchor = Vector2.new(0.5, 1),
		pos = function()
			return UDim2.new(0.5, 0, 1, 0)
		end,
		vlayout {
			pad = padding_types.px8,
		},

		--[[
			We are using values instead of indexes because we should be updatating it when
			amount_owned changes.
		]]
		values(uistore.MyBackpack, function(content, get_item_id)
			local item_id = get_item_id()
			local item_mapped = clientgamedata.item_map[item_id]

			if item_mapped == nil then
				throw_error(`Item id {item_id}'s clientgamedata is nil!!`)
			end
			local o = order()

			return Card {
				content = function()
					return `{item_mapped.display_name} x{content.count}`
				end,
				order = function()
					return o
				end,
			}
		end),
	}
end

return BackpackScreen
