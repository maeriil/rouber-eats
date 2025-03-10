local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

type can<T> = T | () -> T
type props = {
	header: () -> Instance,
	footer: () -> Instance,
	exit: () -> (),
	[number]: any,
}
local px = use_px.px

local function phone_portrait_layout(props: props)
	--//TODO
	-- In our figma design, we added a 16px border outside of this frame, honestly we should
	-- check to see if we need that or not. We want to be consistent with how much pixels
	-- roblox addes on their coregui UIS
	local order = next_order()
	return pane {
		size = UDim2.new(1, 0, 1, 0),
		padding {
			-- we need to add roblox specific
			left = function()
				return UDim.new(0, 96)
			end,
			y = function()
				return UDim.new(0, px(16))
			end,
			right = function()
				return UDim.new(0, px(16))
			end,
		},
		frame {
			color = Color3.fromRGB(100, 100, 100),
			size = UDim2.fromScale(1, 1),
			hlayout {
				pad = function()
					return UDim.new(0, px(16))
				end,
			},

			pane {
				name = "character_view_and_exit",
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				order = order(),
				flexfill {},
				frame {
					-- add a go back to home visual, which uses go_back_page function too
					size = function()
						return UDim2.new(1, 0, 0, px(48))
					end,
				},
				basebutton {
					click = go_back_page,
				},
			},

			frame {
				name = "action button zone",
				size = function()
					return UDim2.new(0, px(72), 1, 0)
				end,
				color = Color3.fromRGB(255, 0, 0),
				order = order(),
			},

			pane {
				name = "potraitphone",
				size = function()
					return UDim2.new(0, px(640), 1, 0)
				end,
				-- color = Color3.fromRGB(0, 255, 0),
				order = order(),
				vlayout {
					pad = function()
						return UDim.new()
					end,
				},
				pane {
					name = "header",
					size = function()
						return UDim2.new(1, 0, 0, px(48))
					end,
					order = order(),
					props.header(),
				},
				frame {
					name = "content",
					color = Color3.fromRGB(0, 0, 255),
					size = function()
						return UDim2.new(1, 0, 1, 0)
					end,
					order = order(),
					flexfill {},
					unpack(props),
				},
				pane {
					name = "footer",
					size = function()
						return UDim2.new(1, 0, 0, px(48))
					end,
					order = order(),
					props.footer(),
				},
			},
		},
	}
end

return phone_portrait_layout
