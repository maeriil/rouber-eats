-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local basebutton        = require(ReplicatedStorage.client.app.components.button.basebutton)
local vpagelayout       = require(ReplicatedStorage.client.app.components.layouts.vpagelayout)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local effect2           = require(ReplicatedStorage.client.app.features.ActiveEffect.effect2)
local pose_entry        = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseList.pose_entry)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local next_order        = require(ReplicatedStorage.common.utility.next_order)
local vide              = require(ReplicatedStorage.pkg.vide)
local types             = require(ReplicatedStorage.types)

local indexes           = vide.indexes
local changed           = vide.changed
local action            = vide.action
local effect            = vide.effect
local source            = vide.source
local px                = use_px.px

type props = {
  content    : types.Source<types.Array<types.rouber_pose_t>>,
  click      : (number) -> (),
  active_idx : types.Source<number>,
}
-- stylua: ignore end

local function calc_offset(idx: number, active_idx: number)
	local final = -1.85 ^ (-1 * (idx - active_idx)) * px(45) + px(45)
	return final
end

local function pose_list(props: props)
  -- stylua: ignore start
  local max_height         = 64
  local order              = next_order()
  local base_pad           = 16
  local filler_cards_count = 4
  local pagelayout         = source() :: types.Source<UIPageLayout>
  local tween_style        = Enum.EasingStyle.Quad
  local tween_direction    = Enum.EasingDirection.Out
  local tween_time         = 0.1
	-- stylua: ignore end

	local function pos_to_translate_by()
		return filler_cards_count * px(max_height) + (filler_cards_count - 1) * px(base_pad)
	end
	local function card_size()
		return UDim2.new(1, 0, 0, px(max_height))
	end
	local function active_pos()
		return UDim2.new(0.5, 0, 0, pos_to_translate_by())
	end
	local function filler_cards(props): { any }
		local t = {}
		for i = 1, filler_cards_count do
			local content = pane {
				name = "root_pad",
				size = card_size,
				order = order(),
			}

			table.insert(t, content)
		end
		return t
	end
	local function change_idx(change_idx: number)
		--[[
      if we are scrolling down, change_idx = -1. Going down means we need to stop at max
      If we are scrolling up, change_idx = 1. Going up means we need to stop at 1
    ]]
		local content = props.content()
		local maxn = #content
		local active = props.active_idx()
		local next_idx = active + -change_idx

		return math.clamp(next_idx, 0, maxn)
	end
	local function disabled()
		return false
	end

	effect(function()
		local page = pagelayout()
		if page then
			page:JumpToIndex(props.active_idx() - 1)
		end
	end)

	-- return pane {
	return {
		-- input_changed = function(input: InputObject)
		-- 	local page = pagelayout()
		-- 	if page and input.UserInputType == Enum.UserInputType.MouseWheel then
		-- 		local z = input.Position.Z
		-- 		-- page:JumpToIndex(if z <= 0 then decrement_idx() else increment_idx())
		-- 		page:JumpToIndex(change_idx(z))
		-- 	end
		-- end,
		pane {
			size = card_size,
			pane {
				size = function()
					return UDim2.new(1.5, 0, 0, px(max_height))
				end,
				anchor = Vector2.new(0.5, 0),
				pos = active_pos,
				effect2 {},
			},
		},
		pane {
			color = Color3.fromRGB(255, 0, 255),
			size = card_size,

			vpagelayout {
				pad = padding_types.px16,
				action(function(page: Instance)
					pagelayout(page :: UIPageLayout)
				end),
				animated_time = tween_time,
				animated_direction = tween_direction,
				animated_style = tween_style,
				scroll_enabled = disabled,
				circular = disabled,
				changed("CurrentPage", function(instance)
					local content = instance :: Frame
					if content then
						local idx = content.LayoutOrder
						local maxn = #props.content()
						local clamped = math.clamp(idx, 0, maxn)

						props.click(clamped)
					end
				end),
			},
			filler_cards {},
			indexes(props.content, function(_content: () -> string | string, idx: number)
				local content = _content :: () -> types.rouber_pose_t
				return pane {
					size = function()
						return UDim2.new(1, 0, 0, px(max_height))
					end,
					order = order(),
					pane {
						color = Color3.fromRGB(0, 150, 250),
						pos = function()
							return UDim2.new(0, calc_offset(idx, props.active_idx()), 0, 0)
						end,
						pose_entry {
							active = function()
								return props.active_idx() == idx
							end,
							blur = function()
								return false
							end,
							pose = content,
						},
					},
					basebutton {
						click = function()
							props.click(idx)
						end,
					},
				}
			end),
		},
	}
end

return pose_list
