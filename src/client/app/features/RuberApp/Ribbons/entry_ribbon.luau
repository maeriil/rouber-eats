local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local entry_card_props = require(ReplicatedStorage.client.app.features.RuberApp.entry_card_props)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local icon = require(ReplicatedStorage.client.app.components.icon.icon)
local padding = require(ReplicatedStorage.client.app.components.padding)
local par = require(ReplicatedStorage.client.app.components.label.par)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local read = vide.read
local potential_words = {
	"delivery",
	"pickup",
	"dropoff",
	"grocery",
}

type can<T> = T | () -> T
type RibbonKind = entry_card_props.OrderType

local function get_stuff(kind: RibbonKind)
	local images = assets.images
	if kind == "delivery" then
		return "Delivery", images["food.png"]
	elseif kind == "grocery" then
		return "Grocery", images["cart.png"]
	end

	return nil, nil
end

local px = use_px.px
local function baseribbon(props: {
	kind: can<RibbonKind>,
	order: can<number>,
})
	local pad16 = function()
		return UDim.new(0, px(16))
	end
	local pad4 = function()
		return UDim.new(0, px(4))
	end
	local pad8 = function()
		return UDim.new(0, px(8))
	end
	local text, img = get_stuff(read(props.kind))

	return frame {
		--//TODO: We should be using gradient and passing it to frame as child
		color = Color3.fromRGB(0, 255, 0),
		order = props.order,
		size = function()
			return UDim2.new(0, px(160), 0, px(32))
		end,
		circle {},
		padding {
			y = pad4,
			x = pad16,
		},
		hlayout {
			pad = pad8,
		},
		icon {
			img = img,
		},
		par {
			text = text_sizes.bolded(text),
		},
	}
end

return baseribbon
