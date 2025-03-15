local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExitButton = require(ReplicatedStorage.client.app.features.Icons.ExitButton)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create

-- local original_canvas_size = Vector2.new(1280, 720) --@ 1920/1080res

export type DashboardProps = {
	-- panelcontent: { any },
	-- content: { any },
	[number]: any,
	original_canvas_size: Vector2,
}

local function dashboard(props: DashboardProps)
	local order = next_order()
	local original_canvas_size = props.original_canvas_size
	local enlarged = original_canvas_size * 1.05
	local exit = go_back_page

	return pane {
		size = function()
			return UDim2.fromOffset(px(enlarged.X), px(enlarged.Y))
		end,
		pos = UDim2.fromScale(0.5, 0.5),
		anchor = Vector2.new(0.5, 0.5),
		frame {
			size = UDim2.fromScale(1, 1),
			color = Color3.fromRGB(200, 50, 50),
			create "UICorner" {
				CornerRadius = padding_types.px16,
			},
		},

		unpack(props),
		ExitButton {
			click = exit,
			anchor = Vector2.new(0.5, 0.5),
			pos = function()
				return UDim2.new(1, 0, 0, 0)
			end,
			-- inverted = true,
		},
	}
end

return dashboard
