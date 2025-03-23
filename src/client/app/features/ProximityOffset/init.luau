local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActionKey = require(script.ActionKey)
local ActionName = require(script.ActionName)
local ProximityText = require(script.ProximityText)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local letter_effect_list = require(ReplicatedStorage.common.utility.letter_effect_list)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

type props = {
	action: types.Can<string>,
	actionkey: types.Can<string>,
	proximitytext: types.Can<string>,
	order: types.Can<number>?,
}

local read = vide.read
local create = vide.create

local function Proximity(props: props)
	return pane {
		color = Color3.fromRGB(255, 0, 0),
		order = props.order,
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,

		hlayout {
			pad = function()
				return UDim.new(0, -1)
			end,
		},
		pane {
			color = Color3.fromRGB(255, 0, 0),
			-- size = function()
			-- 	return UDim2.new(0, px(64), 1, 0)
			-- end,
			size = function()
				return UDim2.new(0.2, 0, 1, 0)
			end,

			-- vlayout {
			-- 	valign = Enum.VerticalAlignment.Center,
			-- },
			ActionKey {
				letter = read(props.actionkey),
				-- pos = UDim2.new(0, px(8), 0, px(8)),
				pos = UDim2.new(0.25, 0, 0.15, 0),
				-- anchor = Vector2.new(1, 0),
			},
		},
		pane {
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			flexfill {},
			pane {
				zindex = 2,
				size = function()
					return UDim2.new(1, 0, 0.5, 0)
				end,
				order = 1,
				ActionName {
					anchor = Vector2.new(0, 0.8),
					pos = UDim2.new(0, 0, 1, 0),
					mainsize = 64,
					text = read(props.action),
					rotation = 0,
					effecttype = letter_effect_list.extremeWaveSize,
				},
			},
			pane {
				size = function()
					return UDim2.new(1, 0, 0.5, 0)
				end,
				pos = function()
					return UDim2.new(0, 0, 1, 0)
				end,
				anchor = function()
					return Vector2.new(0, 1)
				end,
				order = 2,

				ProximityText {
					text = props.proximitytext,
					rotation = -4,
				},
			},
		},
	}
end

return Proximity
