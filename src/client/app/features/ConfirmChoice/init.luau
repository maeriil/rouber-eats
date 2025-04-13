local ReplicatedStorage = game:GetService("ReplicatedStorage")

local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local vide = require(ReplicatedStorage.pkg.vide)

local read = vide.read
local px = use_px.px
local create = vide.create

type props = {
	on_accept: () -> (),
	on_reject: () -> (),
	message: () -> string,
	[number]: any,
}

local function GraffitiText(props: {
	text: () -> string,
})
	return create "TextLabel" {
		Text = props.text,
		Size = UDim2.new(1, 0, 1, 0),
		TextSize = function()
			return px(64)
		end,
		RichText = true,
	}
end

local function Text(props: {
	text: () -> string,
	size: "small" | "medium" | "large",
})
	return create "TextLabel" {
		Text = props.text,
		Size = UDim2.new(1, 0, 1, 0),
		TextWrapped = true,
		TextSize = function()
			if props.size == "small" then
				return px(18)
			elseif props.size == "medium" then
				return px(48)
			elseif props.size == "large" then
				return px(64)
			end

			return px(18)
		end,
		RichText = true,
	}
end

local function ConfirmChoice(props: props)
	local dialogue_header = function()
		return `<b>CHOICE</b>`
	end
	local dialogue_text = function()
		return `This will {props.message()}. Is that OK?`
	end
	local order = next_order()

	local yes = function()
		return "<b>Yes</b>"
	end
	local no = function()
		return "<b>No</b>"
	end

	return frame {
		unpack(props),
		size = function()
			return UDim2.new(0, px(750), 0, px(450))
		end,
		pos = function()
			return UDim2.new(0.5, 0, 0.5, 0)
		end,
		anchor = Vector2.new(0.5, 0.5),
		vlayout {},
		frame {
			order = order(),
			name = "header",
			size = function()
				return UDim2.new(1, 0, 0, px(120))
			end,
			color = Color3.fromRGB(0, 255, 0),
			GraffitiText {
				text = dialogue_header,
			},
		},
		frame {
			order = order(),
			name = "content",
			flexfill {},
			color = Color3.fromRGB(255, 0, 0),
			Text {
				text = dialogue_text,
				size = "large",
			},
		},
		frame {
			order = order(),
			name = "selection",
			size = function()
				return UDim2.new(0.5, 0, 0, px(144))
			end,
			color = Color3.fromRGB(0, 0, 255),
			vlayout {},
			frame {
				basebutton {
					click = props.on_accept,
				},
				order = order(),
				size = function()
					return UDim2.new(1, 0, 0.5, 0)
				end,
				Text {
					text = yes,
					size = "medium",
				},
			},
			frame {
				basebutton {
					click = props.on_reject,
				},
				order = order(),
				size = function()
					return UDim2.new(1, 0, 0.5, 0)
				end,
				Text {
					text = no,
					size = "medium",
				},
			},
		},
	}
end

return ConfirmChoice
