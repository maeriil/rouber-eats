local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local lightgray = require(ReplicatedStorage.client.app.components.gradients.lightgray)
local padding = require(ReplicatedStorage.client.app.components.padding)
local par = require(ReplicatedStorage.client.app.components.label.par)
local slight_rounded = require(ReplicatedStorage.client.app.components.corner.slight_rounded)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
type Source<T> = vide.Source<T>

local px = use_px.px

local function dialogue_frame(props: {
	response: Source<string>,
	author: Source<string>,
})
	return frame {
		size = function()
			return UDim2.new(0.5, 0, 0, px(100))
		end,

		transparency = 0.2,
		lightgray {},
		padding {
			x = function()
				return UDim.new(0, px(16))
			end,
			y = function()
				return UDim.new(0, px(8))
			end,
		},
		par {
			text = props.response,
			xalign = Enum.TextXAlignment.Center,
		},
		slight_rounded {},
	}
end

return dialogue_frame
