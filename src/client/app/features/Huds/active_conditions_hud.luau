-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vlayout           = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local next_order        = require(ReplicatedStorage.common.utility.next_order)
local vide              = require(ReplicatedStorage.pkg.vide)
local types             = require(ReplicatedStorage.types)

local indexes           = vide.indexes
local show              = vide.show
local px                = use_px.px
-- stylua: ignore end

local function bars(props)
	return {
		frame {
			size = function()
				return UDim2.new(0, px(4), 1, 0)
			end,
		},
		frame {
			size = function()
				return UDim2.new(0, px(4), 1, 0)
			end,
			pos = UDim2.new(1, 0, 0, 0),
			anchor = Vector2.new(1, 0),
		},
	}
end

local function condition_desc(props: {
	cond: types.Source<string>,
	order: number,
	is_active: () -> boolean,
})
	return pane {
		size = function()
			return UDim2.new(1, 0, 0, px(64))
		end,
		frame {
			size = function()
				return UDim2.new(0.9, 0, 0.4, 0)
			end,
			pos = UDim2.fromScale(0.5, 0.5),
			anchor = Vector2.new(0.5, 0.5),
			transparency = 0.65,
			color = Color3.fromRGB(),
		},
		pane {
			size = function()
				return UDim2.new(0.9, 0, 1, 0)
			end,
			pos = UDim2.new(0.5, 0, 0.5, 0),
			anchor = Vector2.new(0.5, 0.5),
			rtext {
				text = props.cond,
				-- bolded = true,
				italic = true,
				size = "sm",
				wrap = true,
				xalign = Enum.TextXAlignment.Right,
				color = function()
					return Color3.fromRGB(255, 255, 255)
				end,
			},
		},
		show(props.is_active, function()
			return bars {}
		end),
	}
end

type props = {
	conditions_list: types.Source<types.Array<string>>,
}

local function active_conditions(props: props)
	local order = next_order()

	return pane {
		size = function()
			return UDim2.new(0, px(450), 0, px(600))
		end,
		vlayout {
			pad = padding_types.px16,
		},
		indexes(props.conditions_list, function(cond: () -> string, n: number)
			return condition_desc {
				cond = cond,
				order = order(),
				is_active = function()
					return n == 1
				end,
			}
		end),
	}
end

return active_conditions
