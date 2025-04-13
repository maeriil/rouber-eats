-- stylua: ignore start
local ReplicatedStorage     = game:GetService("ReplicatedStorage")

local basebutton            = require(ReplicatedStorage.client.app.components.button.basebutton)
local frame                 = require(ReplicatedStorage.client.app.components.pane.frame)
local padding               = require(ReplicatedStorage.client.app.components.padding)
local padding_types         = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane                  = require(ReplicatedStorage.client.app.components.pane.pane)
local square                = require(ReplicatedStorage.client.app.components.ratio.square)
local HintSection           = require(ReplicatedStorage.client.app.pages.PosesScreen.HintSection)
local PoseList              = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseList)
local PoseSelectButton      = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseSelectButton)
local PoseSelectChoiceModal = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseSelectChoiceModal)
local PoseViewport          = require(ReplicatedStorage.client.app.pages.PosesScreen.PoseViewport)
local StrikePoseTitle       = require(ReplicatedStorage.client.app.pages.PosesScreen.StrikePoseTitle)
local uistore               = require(ReplicatedStorage.client.app.uistore)
local eventqueue            = require(ReplicatedStorage.client.app.uistore.eventqueue)
local use_px                = require(ReplicatedStorage.client.app.utility.use_px)
local poses                 = require(ReplicatedStorage.common.configs.poses)
local vide                  = require(ReplicatedStorage.pkg.vide)
local types                 = require(ReplicatedStorage.types)

local px                    = use_px.px
local source                = vide.source
local effect                = vide.effect
local show                  = vide.show
-- stylua: ignore end
--[[
  The screen will really only show up when we are delivering the food to the house and
  we are in middle of animation. Then, we will display the poses list so that player can choice
  which pose they would like to play.

  So each button click would result in a popup that says Confirm Selection and then once its
  confirmed, we dispatch event to the event queue.

  In the eventqueue, it will
    1. Send event to the server about the pose selection
    2. Close the UI
    3. If there are more orders, it will reshow it for the new order id
  Once all of them are complete, then the cutscene will resume

]]

--[[
	On choice selection, what should happen? I think we need to dispatch to event queue
	Then we will play unmount animation on this screen
]]

local function PosesScreen(props)
	-- The selected pose will only contain the key of the pose. We need to do config lookup
	-- to grab the animation details and etc
	-- The order details should come from the UI store i think
	-- Game will render the poses that player owns, there should be options for filters
	-- By removing some filters u can filter by category, by owned/unowned or none and etc
-- stylua: ignore start
  local selected_pose     = source(1)
  local active_order      = uistore.ActiveOrder
  local pose_list         = uistore.pose_list
  local mymodel           = uistore.MyModel :: types.Source<Model>
  local confirm_selection = source(false)
  local hint_description  = uistore.hint_description
	-- stylua: ignore end

	local function get_track()
		local curr_selected = selected_pose()
		local list = pose_list()
		local pose_name = list[curr_selected]
		local pose_details = poses[pose_name :: never]

		if pose_details ~= nil then
			local anim = pose_details.animation_id
			return anim
		end
		return nil :: never
	end

	local animation_to_play = source(get_track()) :: types.Source<Animation>

	effect(function()
		animation_to_play(get_track())
	end)

	return frame {
		color = Color3.fromRGB(0, 150, 240),
		padding {
			x = padding_types.px48, -- iphone left right unsafe space
			y = padding_types.px32,
		},

		pane {
			name = "pose-list-container",
			size = function()
				return UDim2.new(0.4, 0, 0.75, 0)
			end,
			pos = function()
				return UDim2.new(0.1, 0, 1, -px(96))
			end,
			anchor = Vector2.new(0.1, 1),
			PoseList {
				active_idx = selected_pose,
				click = selected_pose,
				content = pose_list,
			},
		},
		pane {
			name = "char-viewport-details-container",
			size = function()
				return UDim2.new(0.45, 0, 0.75, 0)
			end,
			pos = function()
				return UDim2.new(1, 0, 1, -px(96))
			end,
			anchor = Vector2.new(1, 1),
			PoseViewport {
				model = mymodel,
				animation_to_play = animation_to_play,
				pose = function()
					local curr_selected = selected_pose()
					local list = pose_list()
					local pose_name = list[curr_selected]
					local pose_details = poses[pose_name :: never]
					return pose_details.display_name
				end,
			},
		},
		StrikePoseTitle {},
		HintSection {
			hint = hint_description,
			pos = function()
				return UDim2.new(0.15, 0, 1, 0)
			end,
			anchor = function()
				return Vector2.new(0.15, 1)
			end,
		},
		pane {
			size = function()
				return UDim2.new(0, px(256), 0, px(128))
			end,
			pos = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			anchor = Vector2.new(1, 1),
			PoseSelectButton {},
			basebutton {
				click = function()
					confirm_selection(true)
				end,
			},
		},

		-- Popup modal that contains yes/no choice
		show(confirm_selection, function()
			return pane {
				size = function()
					return UDim2.new(0.45, 0, 0.45, 0)
				end,
				pos = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				anchor = function()
					return Vector2.new(0.5, 0.5)
				end,
				PoseSelectChoiceModal {
					yes = function()
						local content = pose_list()
						local selected = content[selected_pose()]
						eventqueue.dispatch_pose_select(selected)
					end,
					no = function()
						confirm_selection(false)
					end,
				},
				square {},
			}
		end),
	}
end

return PosesScreen
