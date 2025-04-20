local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExitButton = require(ReplicatedStorage.client.app.features.Icons.ExitButton)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local assets = require(ReplicatedStorage.assets.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local backpack_navbar = require(ReplicatedStorage.client.app.pages.BackpackScreen.backpack_navbar)
local backpack_poses =
	require(ReplicatedStorage.client.app.pages.BackpackScreen.pages.backpack_poses)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)

local px = use_px.px
local source = vide.source
local switch = vide.switch

type backpack_pages = "backpack_poses" | "backpack_furnishings"
type props = {}

local function BackpackScreen(props)
	-- local order = next_order()
	-- return frame {
	-- 	close_on_click_outside(go_back_page),
	-- 	color = Color3.fromRGB(200, 50, 0),
	-- 	size = function()
	-- 		return UDim2.new(0.85, 0, 0.5, 0)
	-- 	end,
	-- 	anchor = Vector2.new(0.5, 1),
	-- 	pos = function()
	-- 		return UDim2.new(0.5, 0, 1, 0)
	-- 	end,
	-- 	vlayout {
	-- 		pad = padding_types.px8,
	-- 	},

	-- 	--[[
	-- 		We are using values instead of indexes because we should be updatating it when
	-- 		amount_owned changes.
	-- 	]]
	-- 	values(uistore.MyBackpack, function(content, get_item_id)
	-- 		local item_id = get_item_id()
	-- 		local item_mapped = clientgamedata.item_map[item_id]

	-- 		if item_mapped == nil then
	-- 			throw_error(`Item id {item_id}'s clientgamedata is nil!!`)
	-- 		end
	-- 		local o = order()

	-- 		return Card {
	-- 			content = function()
	-- 				return `{item_mapped.display_name} x{content.count}`
	-- 			end,
	-- 			order = function()
	-- 				return o
	-- 			end,
	-- 		}
	-- 	end),
	-- }

	local basesize = Vector2.new(1280, 720)
	local size = function()
		return UDim2.new(0, px(basesize.X), 0, px(basesize.Y))
	end
	local image = assets.images["container_frame1.svg"]
	local currpage = source("backpack_furnishings")

	local furnishings_page: backpack_pages = "backpack_furnishings"
	local poses_page: backpack_pages = "backpack_poses"

	local pages = {
		{ name = "Furnishings", page_name = "backpack_furnishings" },
		{ name = "Poses", page_name = "backpack_poses" },
	} :: types.Array<{ name: string, page_name: backpack_pages }>
	local page_navbar_render = {}
	for i, details in pages do
		table.insert(
			page_navbar_render,
			backpack_navbar {
				text = function()
					return details.name
				end,
				is_active = function()
					return details.page_name == currpage()
				end,
				basebutton {
					click = function()
						currpage(details.page_name)
					end,
				},
			}
		)
	end

	return pane {
		size = size,
		anchor = Vector2.new(0.5, 0.5),
		pos = UDim2.new(0.5, 0, 0.5, 0),
		baseimage {
			img = image,
			color = function()
				return Color3.fromRGB(255, 255, 255)
			end,
		},
		--Move this all the way down in the end
		ExitButton {
			click = go_back_page,
			anchor = Vector2.new(0.5, 0.5),
			pos = function()
				return UDim2.new(1, 0, 0, 0)
			end,
		},

		pane {
			size = function()
				return UDim2.new(1, 0, 1, -px(36 * 2))
			end,
			anchor = Vector2.new(0.5, 0.5),
			pos = UDim2.fromScale(0.5, 0.5),
			hlayout {},
			pane {
				name = "navbar-container",
				size = function()
					return UDim2.new(0, px(192), 1, 0)
				end,
				pos = UDim2.new(0, 0, 0.5, 0),
				anchor = Vector2.new(0, 0.5),
				padding {
					x = padding_types.nopad,
					y = padding_types.px48,
				},
				vlayout {
					pad = padding_types.px16,
				},
				page_navbar_render,
			},
			pane {
				color = Color3.fromRGB(0, 255, 0),
				name = "content-container",
				flexfill {},
				pos = UDim2.new(0, 0, 0.5, 0),
				anchor = Vector2.new(0, 0.5),

				switch(currpage) {
					[furnishings_page] = function()
						return frame {}
					end,
					[poses_page] = function()
						return backpack_poses {}
					end,
				},
			},
		},
	}
end

return BackpackScreen
