-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vlayout           = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)

local px                = use_px.px
-- stylua: ignore end

--//TODO: we should be putting all the colours into a colorscheme in a single file or context
--//TODO: Translation stuff might be tricky with how we are using rich text here... figure it out

local function pickup_order_text(props: {
	textcolor: () -> Color3,
})
	return rtext {
		text = function()
			return `ReQu<font color="#fff">e</font>ST`
		end,
		size = "sm",
		bolded = true,
		italic = true,
		color = props.textcolor,
		xalign = Enum.TextXAlignment.Right,
	}
end

local function description(props: {
	order_owner_name: () -> string,
	textcolor: () -> Color3,
})
	return rtext {
		text = function()
			return `Pickup {props.order_owner_name()}'s order!`
		end,
		size = "sm",
		bolded = true,
		color = props.textcolor,
	}
end

type props = {
	details: () -> string,
}

local function pickup_order_hud(props: props)
	local hud_colour = function()
		return Color3.fromRGB(255, 0, 0)
	end
	local content_color = function()
		return Color3.fromRGB(255, 255, 255)
	end
	local transparency = 0.1

	return pane {
		size = function()
			return UDim2.new(0, px(450), 0, px(72))
		end,
		vlayout {},
		pane {
			size = function()
				return UDim2.fromScale(1, 0.6)
			end,
			order = 1,
			pickup_order_text {
				textcolor = hud_colour,
			},
		},
		frame {
			size = function()
				return UDim2.fromScale(1, 0.4)
			end,
			order = 2,
			color = hud_colour,
			transparency = transparency,
			description {
				textcolor = content_color,
				order_owner_name = props.details,
			},
		},
	}
end

return pickup_order_hud
