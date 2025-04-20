local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local DoorProximity = require(script.features.Proximity.Attaching.DoorProximity)

-- stylua: ignore start
local billboard = require(ReplicatedStorage.client.app.components.billboard)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)
local Result = require(ReplicatedStorage.client.app.features.Result)
local result_non_billboard = require(ReplicatedStorage.client.app.features.Result.result_non_billboard)
local result_sources = require(ReplicatedStorage.client.app.features.Result.result_sources)
local FallbackScreen = require(ReplicatedStorage.client.app.pages.FallbackScreen)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local BackpackScreen    = require(script.pages.BackpackScreen)
local DialogueProximity = require(script.features.Proximity.DialogueProximity)
local DialogueScene     = require(script.pages.DialogueScene)
local DoorProximity     = require(script.features.Proximity.DoorProximity)
local HudScreen         = require(script.pages.HudScreen)
local ItemProximity     = require(script.features.Proximity.ItemProximity)
local MailboxProximity  = require(script.features.Proximity.MailboxProximity)
local PhoneScreen       = require(script.pages.PhoneScreen)
local PosesScreen       = require(script.pages.PosesScreen)
local RouberScreen      = require(script.pages.RouberScreen)
local frame             = require(script.components.pane.frame)
local types             = require(ReplicatedStorage.types)
local uistore           = require(script.uistore)
local use_px            = require(script.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)

local create            = vide.create
local switch            = vide.switch
local indexes           = vide.indexes
local show              = vide.show
local effect = vide.effect
local px = use_px.px
-- stylua: ignore end

local function root(): { any }
	-- stylua: ignore start
  local hud           : types.GamePages = "HudScreen"
  local phone         : types.GamePages = "PhoneScreen"
  local rouber        : types.GamePages = "RouberScreen"
  local dialoguescene : types.GamePages = "DialogueScene"
  local backpack      : types.GamePages = "BackpackScreen"
  local poses         : types.GamePages = "pose_screen"
  local reward        : types.GamePages = "reward_screen"

  local page          = uistore.page
  local alldoors      = uistore.DoorProximity
  local all_dialogues = uistore.DialogueProximity
	-- stylua: ignore end
	use_px.use_px()

	return {
		create "ScreenGui" {
			use_px.use_px(),
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.None,

			indexes(alldoors, function(details: () -> types.DoorProximityDetails, _: number)
				return DoorProximity {
					details = details,
				}
			end),

			indexes(all_dialogues, function(details: () -> types.DialogueProximityDetails, n: number)
				return DialogueProximity {
					details = details,
				}
			end),

			indexes(
				uistore.MailboxProximity,
				function(details: () -> types.MailboxProximityDetails, a1: number)
					return MailboxProximity {
						details = details,
					}
				end
			),

			indexes(
				uistore.ItemProximity,
				function(details: () -> types.ItemProximityDetails, a1: number)
					return ItemProximity {
						details = details,
					}
				end
			),

			-- show(result_sources.start_result_animation, function()
			-- 	local player = Players.LocalPlayer
			-- 	local character = player.Character
			-- 	local camera = workspace.CurrentCamera
			-- 	assert(character, "Character must be defined by now")

			-- 	return {
			-- 		billboard {
			-- 			adornee = character,
			-- 			offset = function()
			-- 				return vector.create(-2, 0, 0)
			-- 			end,
			-- 			size = function()
			-- 				-- Its off my a little bit, will need to investigate that part
			-- 				local curr_viewport = camera.ViewportSize
			-- 				local cam_cf = camera.CFrame
			-- 				local fov = camera.FieldOfView
			-- 				local my_cf = character.PrimaryPart.CFrame
			-- 				local dist = (cam_cf.Position - my_cf.Position).Magnitude
			-- 				local h = math.tan(math.rad(fov / 2)) * 2 * dist
			-- 				local w = (curr_viewport.X / curr_viewport.y) * h

			-- 				return UDim2.fromScale(w, h)
			-- 			end,
			-- 			-- Result {},
			-- 			frame {
			-- 				size = UDim2.new(1, 0, 1, 0),
			-- 				color = Color3.fromRGB(255, 0, 0),
			-- 			},
			-- 		},
			-- 		-- result_non_billboard {},
			-- 	} :: { any }
			-- end),

			switch(page) {
				[""] = function()
					return FallbackScreen {}
				end,
				[hud] = function()
					return HudScreen {}
				end,
				[phone] = function()
					return PhoneScreen {}
				end,
				[rouber] = function()
					return RouberScreen {
						eventqueue.add_ui_openclose_event(rouber),
					}
				end,
				[dialoguescene] = function()
					return DialogueScene {}
				end,
				[backpack] = function()
					return BackpackScreen {}
				end,
				[poses] = function()
					return PosesScreen {}
				end,
				[reward] = function()
					return Result {}
				end,
			},
		},
	}
end

return root
