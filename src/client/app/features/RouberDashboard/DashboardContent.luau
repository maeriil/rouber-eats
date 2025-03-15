local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SidepanelCard = require(script.Parent.SidepanelCard)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)

local px = use_px.px

local function DashboardContent(props: {
	original_canvas_size: Vector2,
	panelcontent: {},
	content: {},
})
	local order = next_order()
	local original_canvas_size = props.original_canvas_size

	return frame {
		size = function()
			return UDim2.new(0, px(original_canvas_size.X), 0, px(original_canvas_size.Y))
		end,
		pos = UDim2.fromScale(0.5, 0.5),
		anchor = Vector2.new(0.5, 0.5),
		hlayout {},
		SidepanelCard {
			order = order(),
			-- Add contents here to put to the side panel
			props.panelcontent,
		},

		pane {
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			flexfill {},
			props.content,
		},
	}
end

return DashboardContent
