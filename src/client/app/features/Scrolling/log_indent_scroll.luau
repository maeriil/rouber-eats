local ReplicatedStorage = game:GetService("ReplicatedStorage")

local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local vpagelayout = require(ReplicatedStorage.client.app.components.layouts.vpagelayout)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local effect2 = require(ReplicatedStorage.client.app.features.ActiveEffect.effect2)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)

local create = vide.create
local indexes = vide.indexes
local px = use_px.px
local show = vide.show
local derive = vide.derive
local source = vide.source
local action = vide.action
local changed = vide.changed
local effect = vide.effect

type content_type = {
	icon: string,
	text: string,
	rating: number,
}

local function entry(props: {
	active_idx: () -> number,
	click: () -> (),
	content: () -> content_type,
}): { any }
	return {
		create "TextLabel" {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = function()
				return props.content().text
			end,
			TextSize = function()
				return px(64)
			end,
		},
		basebutton {
			click = props.click,
		},
	}
end

type props = {
	content: types.Source<types.Array<content_type>>,
	click: (number) -> (),
	active_idx: () -> number,
}

-- local function log_indent_scroll_frame(props: props): { any }
-- 	local config = {
-- 		delayTime = 0,
-- 		direction = Enum.EasingDirection.Out,
-- 		style = Enum.EasingStyle.Linear,
-- 		repeatCount = 0,
-- 		reverses = false,
-- 		time = 0.3,
-- 	}

-- 	local items_order = next_order()
-- 	local card_height = 128
-- 	local card_size = function()
-- 		return UDim2.new(1, 0, 0, px(card_height))
-- 	end
-- 	local filler_cards_count = 4
-- 	local canvas_position = source(Vector2.new())

-- 	local function filler_cards(props)
-- 		local t = {}
-- 		for i = 1, filler_cards_count do
-- 			local content = frame {
-- 				name = "root_pad",
-- 				size = card_size,
-- 				order = items_order(),
-- 			}

-- 			table.insert(t, content)
-- 		end`
-- 		return t
-- 	end

-- 	local pos_to_translate_by = function()
-- 		return filler_cards_count * px(card_height) + (filler_cards_count - 1) * px(16)
-- 	end
-- 	local active_pos, mp1 = use_motion(UDim2.new(0.5, calc_offset(1), 0, pos_to_translate_by()))

-- 	effect(function()
-- 		print("pos changed, we need to push the items above... @", canvas_position())
-- 	end)

-- 	return {
-- 		create "ScrollingFrame" {
-- 			Size = function()
-- 				return UDim2.new(1, 0, 1, 0)
-- 			end,
-- 			CanvasSize = UDim2.new(1, 0, 1, 0),
-- 			AutomaticCanvasSize = Enum.AutomaticSize.Y,
-- 			ScrollingDirection = Enum.ScrollingDirection.Y,
-- 			BackgroundTransparency = 1,
-- 			ClipsDescendants = false,
-- 			changed("CanvasPosition", canvas_position),

-- 			create "Folder" {
-- 				pane {
-- 					size = function()
-- 						return UDim2.new(1.5, 0, 0, px(128))
-- 					end,
-- 					anchor = Vector2.new(0.5, 0),
-- 					pos = active_pos,
-- 					effect2 {},
-- 				},
-- 			},

-- 			vlayout {
-- 				pad = padding_types.px16,
-- 			},
-- 			filler_cards {},

-- 			indexes(props.content, function(_content, idx: number)
-- 				local content = _content()
-- 				local offset = calc_offset(idx)

-- 				return pane {
-- 					size = function()
-- 						return UDim2.new(1, 0, 0, px(128))
-- 					end,
-- 					order = items_order(),
-- 					pane {
-- 						color = Color3.fromRGB(0, 150, 250),
-- 						pos = function()
-- 							return UDim2.new(0, offset, 0, 0)
-- 						end,
-- 						entry {
-- 							active_idx = props.active_idx,
-- 							click = function()
-- 								mp1:tween(
-- 									UDim2.new(0.5, offset, 0, (px(128) + px(16)) * (idx - 1) + pos_to_translate_by()),
-- 									config
-- 								)
-- 								props.click(idx)
-- 							end,
-- 							content = function()
-- 								return content
-- 							end,
-- 						},
-- 					},
-- 				}
-- 			end),
-- 		},
-- 	}
-- end

local function calc_offset(my_idx: number, active_idx: number)
	local final = -1.85 ^ (-1 * (my_idx - active_idx)) * px(45) + px(45)
	-- print(final)

	return final
end

local function log_indent_scroll_frame(props: props)
	local items_order = next_order()
	local card_height = 128
	local card_size = function()
		return UDim2.new(1, 0, 0, px(card_height))
	end

	local filler_cards_count = 4
	local pagelayout = source() :: types.Source<UIPageLayout>
	local pos_to_translate_by = function()
		return filler_cards_count * px(card_height) + (filler_cards_count - 1) * px(16)
	end
	-- local active_pos, mp1 = use_motion(UDim2.new(0.5, calc_offset(1), 0, pos_to_translate_by()))
	local active_pos = function()
		return UDim2.new(0.5, 0, 0, pos_to_translate_by())
	end

	effect(function()
		local page = pagelayout()
		if page then
			page:JumpToIndex(props.active_idx() - 1)
		end
	end)

	local function filler_cards(props)
		local t = {}
		for i = 1, filler_cards_count do
			local content = frame {
				name = "root_pad",
				size = card_size,
				order = items_order(),
			}

			table.insert(t, content)
		end
		return t
	end

	return {
		frame {
			color = Color3.fromRGB(255, 0, 255),
			size = card_size,
			vpagelayout {
				pad = padding_types.px16,
				action(function(page: Instance)
					pagelayout(page :: UIPageLayout)
				end),
				animated_time = 0.2,
				scroll_enabled = true,
				-- on_page_stopped = function(instance)
				-- 	-- this is the current page, mark it as curr
				-- 	local content = instance :: Frame
				-- 	if content then
				-- 		local idx = content.LayoutOrder
				-- 		props.click(idx)
				-- 	end
				-- end,
				changed("CurrentPage", function(instance)
					print(`curr page = {instance}`)
					local content = instance :: Frame
					if content then
						local idx = content.LayoutOrder
						props.click(idx)
					end
				end),
			},
			filler_cards {},
			indexes(props.content, function(_content, idx: number)
				-- local content = _content()
				local content = _content :: () -> content_type
				return pane {
					size = function()
						return UDim2.new(1, 0, 0, px(128))
					end,
					order = items_order(),
					frame {
						color = Color3.fromRGB(0, 150, 250),
						pos = function()
							return UDim2.new(0, calc_offset(idx, props.active_idx()), 0, 0)
						end,
						entry {
							active_idx = props.active_idx,
							click = function()
								-- mp1:tween(
								-- 	UDim2.new(0.5, offset, 0, (px(128) + px(16)) * (idx - 1) + pos_to_translate_by()),
								-- 	config
								-- )
								props.click(idx)
							end,
							content = content,
						},
					},
				}
			end),
		},
		pane {
			size = card_size,
			pane {
				size = function()
					return UDim2.new(1.5, 0, 0, px(128))
				end,
				anchor = Vector2.new(0.5, 0),
				pos = active_pos,
				effect2 {},
			},
		},
	}
end

return log_indent_scroll_frame
