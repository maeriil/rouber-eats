local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EnterAction = require(ReplicatedStorage.client.app.features.Graffiti.Presets.EnterAction)
local ProximityKey = require(script.Parent.ProximityKey)
local ProximityPresenceIcon = require(script.Parent.ProximityPresenceIcon)
local ProximityText = require(script.Parent.ProximityText)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local billboard = require(ReplicatedStorage.client.app.components.billboard)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local squarescale = require(ReplicatedStorage.client.app.components.ratio.squarescale)
local types = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local derive = vide.derive
local show = vide.show

type props = {
	details: types.Source<types.DoorProximityDetails>,
}

local function MainProximity(props: {
	details: () -> types.DoorProximityDetails,
})
	local details = props.details

	return pane {
		size = UDim2.new(0.9, 0, 1, 0),
		pos = UDim2.new(0.5, 0.5),
		anchor = Vector2.new(0.5, 0.5),
		basebutton {
			click = function()
				eventqueue.dispatch_proximity_clicked(uistore.ActiveProximity())
			end,
		},

		pane {
			size = UDim2.new(1, 0, 1, 0),
			vlayout {},
			pane {
				name = "top",
				size = UDim2.new(1, 0, 0.6, 0),
				pos = UDim2.new(0, 0, 0.25, 0),
				zindex = 2,
				frame {
					size = UDim2.new(0.7, 0, 0.5, 0),
					anchor = Vector2.new(0, 0.5),
					pos = UDim2.new(0, 0, 0.5, 0),
					color = Color3.fromRGB(),
				},
				EnterAction {
					rotation = -4,
				},
			},
			pane {
				name = "bottom",
				size = UDim2.new(1, 0, 0.4, 0),
				color = Color3.fromRGB(100, 0, 200),
				pane {
					size = UDim2.fromScale(1, 1),
					anchor = Vector2.new(0, 0.5),
					pos = UDim2.new(0, 0, 0.1, 0),
					rotation = 0,
					ProximityText {
						text = details().proximity_text,
						rotation = -4,
						inverted = true,
					},
					pane {
						name = "LEFT",
						size = UDim2.new(0, 0, 1, 0),
						squarescale {},
						anchor = Vector2.new(1, 1),
						pos = UDim2.fromScale(0.05, 1),
						ProximityKey {
							letter = `e`, -- ECS should contain keybind, we should use that
						},
					},
				},
			},
		},
	}
end

local function DoorProximity(props: props)
	local details = derive(props.details)
	local adornee = function()
		return details().adornee
	end

	local proximity_type_display = function()
		return details().promptid == uistore.ActiveProximity()
	end

	local function adjust_offset()
		return if proximity_type_display() then vector.create(0, 1, 3) else vector.create(0, 5, 0)
	end

	return billboard {
		max_distance = 75,
		offset = adjust_offset,
		adornee = adornee,
		size = function()
			if proximity_type_display() then
				return UDim2.new(10, 0, 5, 0)
			end
			return UDim2.new(4, 0, 4, 0)
		end,

		show(proximity_type_display, function()
			return MainProximity {
				details = details,
			}
		end, function()
			return ProximityPresenceIcon {}
		end),
	}
end

return DoorProximity
