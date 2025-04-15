local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChoiceSection =
	require(ReplicatedStorage.client.app.features.Dialogues.Sections.ChoiceSection)
local DialogueAvatar = require(script.Parent.DialogueAvatar)
local ResponseDialogue = require(script.Parent.ResponseDialogue)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local ripple = require(ReplicatedStorage.pkg.ripple)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local source = vide.source
local effect = vide.effect
local px = use_px.px
local show = vide.show
local untrack = vide.untrack

type props = {}

local noob = workspace:FindFirstChild("Noob")
local player = Players.LocalPlayer
local function DialogueScene(props: props)
	local char = player.Character

	if char then
	else
		warn(`Using a fallback dialogue character. This should never happen in Prod`)
		char = workspace:FindFirstChild("Maeriil")
	end

	local order = next_order()
	-- local widthscalesize = source(0.15)
	local author = uistore.DialogueAuthor
	local responsetext = uistore.DialogueResponse
	local prev_responsetext = source("")
	local textanimate = source(false)
	local showchoices = source(false)

	local goal_sz = 0.25
	local widthscalesize, widthscalemotion = use_motion(goal_sz)

	effect(function()
		local curr = responsetext()
		local prev = untrack(prev_responsetext)

		if curr ~= prev then
			textanimate(true)
			prev_responsetext(curr)
		end
	end)

	effect(function()
		local list = uistore.DialogueChoices()
		if #list > 0 then
			--//TODO: We might want to configure these animations a bit tbh...
			showchoices(true)
			widthscalemotion:spring(0, ripple.config.spring.stiff :: never)
		else
			showchoices(false)
			widthscalemotion:spring(goal_sz, ripple.config.spring.stiff :: never)
		end
	end)

	return pane {
		size = UDim2.new(1, 0, 1, 0),
		hlayout {
			valign = Enum.VerticalAlignment.Bottom,
		},
		pane {
			name = "'leftempty",
			size = function()
				return UDim2.new(widthscalesize(), 0, 1, 0)
			end,
			order = order(),
			color = Color3.fromRGB(255, 255, 0),
		},

		pane {
			size = UDim2.new(1, 0, 0.5, 0),
			order = order(),
			flexfill {},

			hlayout {},
			pane {
				color = Color3.fromRGB(0, 255, 0),
				size = UDim2.new(0, px(240), 0.8, 0),
				order = order(),

				DialogueAvatar {
					model = noob,
					size = UDim2.new(1, 0, 1, 0),
					pos = UDim2.new(0.5, 0, 1, 0),
					anchor = Vector2.new(0.5, 1),
				},
			},

			pane {
				color = Color3.fromRGB(0, 0, 255),
				size = UDim2.new(1, 0, 0.8, 0),
				order = order(),
				ResponseDialogue {
					pos = UDim2.new(0.5, 0, 1, 0),
					anchor = Vector2.new(0.5, 1),
					text = responsetext,
					author = author,
					click = function()
						eventqueue.dispatch_next_dialogue(uistore.MyDialogueId() :: never)
					end,
					animate = textanimate,
				},

				flexfill {},
			},
		},

		pane {
			order = order(),
			size = function()
				return UDim2.new(0.25 + (goal_sz - widthscalesize()), 0, 1, 0)
			end,
			show(showchoices, function()
				return ChoiceSection {
					choices = uistore.DialogueChoices,
					mycharacter = char,
				}
			end),
		},
	}
end

return DialogueScene
