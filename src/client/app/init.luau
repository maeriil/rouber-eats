local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local DoorProximity = require(script.features.Proximity.Attaching.DoorProximity)

-- stylua: ignore start
local BackpackScreen    = require(script.pages.BackpackScreen)
local DialogueProximity = require(script.features.Proximity.DialogueProximity)
local DialogueScene     = require(script.pages.DialogueScene)
local DoorProximity     = require(script.features.Proximity.DoorProximity)
local HudScreen         = require(script.pages.HudScreen)
local ItemProximity     = require(script.features.Proximity.ItemProximity)
local MailboxProximity  = require(script.features.Proximity.MailboxProximity)
local PhoneScreen       = require(script.pages.PhoneScreen)
local PosesScreen = require(script.pages.PosesScreen)
local RouberScreen      = require(script.pages.RouberScreen)
local frame             = require(script.components.pane.frame)
local types             = require(ReplicatedStorage.types)
local uistore           = require(script.uistore)
local use_px            = require(script.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)

local create  = vide.create
local switch  = vide.switch
local indexes = vide.indexes
-- stylua: ignore end

local function root(): { any }
	-- stylua: ignore start
  local hud           : types.GamePages = "HudScreen"
  local phone         : types.GamePages = "PhoneScreen"
  local rouber        : types.GamePages = "RouberScreen"
  local dialoguescene : types.GamePages = "DialogueScene"
  local backpack      : types.GamePages = "BackpackScreen"
  local poses         : types.GamePages = "pose_screen"

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

			switch(page) {
				[""] = function()
					return frame {
						size = UDim2.new(1, 0, 1, 0),
						create "TextLabel" {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							TextSize = 96,
							Text = "Unkown page is shown",
						},
					}
				end,
				[hud] = function()
					return HudScreen {}
				end,
				[phone] = function()
					return PhoneScreen {}
				end,
				[rouber] = function()
					return RouberScreen {}
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
			},
		},
	}
end

return root
