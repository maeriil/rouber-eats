local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local jecs = require(ReplicatedStorage.pkg.jecs)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity
type can<T> = T | () -> T
type Source<T> = vide.Source<T>

local values = vide.values
local px = use_px.px
local read = vide.read

local function dialogue_choice(props: {
	text: can<string>,
	order: can<number>,
	id: can<Entity>,
	pass: (id: Entity) -> (),
})
	return frame {
		color = Color3.fromRGB(0, 255, 0),
		size = function()
			return UDim2.new(1, 0, 0, px(32))
		end,
		padding {
			x = function()
				return UDim.new(0, px(16))
			end,
		},
		basebutton {
			click = function()
				props.pass(read(props.id))
			end,
		},
		par {
			text = props.text,
			wrap = true,
		},
		order = props.order,
	}
end

local function choices(props: {
	list: Source<{ { id: Entity, text: string } }>,
	pass: (id: Entity) -> (),
})
	local order = next_order()
	return pane {
		size = function()
			return UDim2.new(0.4, 0, 0.5, 0)
		end,
		pos = UDim2.new(1, 0, 0.5, 0),
		anchor = Vector2.new(1, 0.5),
		vlayout {
			valign = Enum.VerticalAlignment.Center,
			pad = function()
				return UDim.new(0, px(16))
			end,
		},

		values(props.list, function(src: { id: Entity, text: string }, a1: () -> number)
			return dialogue_choice {
				text = function()
					return src.text
				end,
				order = order(),
				id = function()
					return src.id
				end,
				pass = props.pass,
			}
		end),
	}
end

return choices
