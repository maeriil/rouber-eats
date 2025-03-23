local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Proximity = require(script.Parent.Parent)
local ProximityDistanceIcon =
	require(ReplicatedStorage.client.app.features.Proximity.ProximityDistanceIcon)
local assets = require(ReplicatedStorage.assets)
local billboard = require(ReplicatedStorage.client.app.components.billboard)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local source = vide.source
local derive = vide.derive
local show = vide.show
local effect = vide.effect
local create = vide.create

type props = {
	details: types.Source<types.DoorProximityDetails>,
}

local function proximityprompt(props: {})
	return create "ProximityPrompt" {
		ClickablePrompt = true,
		HoldDuration = 0.5,
		MaxActivationDistance = 8,
		Style = Enum.ProximityPromptStyle.Custom,
	}
end

local function DoorProximity(props: props)
	local details = derive(props.details)
	local prompt_size = UDim2.new(12, 0, 3, 0)
	local icon_size = UDim2.new(4, 0, 4, 0)

	local billboard_size = source(icon_size)

	local adornee = function()
		return details().adornee
	end
	local text = function()
		return details().proximity_text
	end
	local action = function()
		return if details().exterior then "ENTER!" else "LEAVE!"
	end
	-- This should be set Enter if we are exterior, EXIT if we are interior
	local fallback_icon = assets.images["ExclamationIcon.svg"]
	local display_proximity = function()
		return details().distance <= 8
	end

	effect(function()
		if display_proximity() then
			billboard_size(prompt_size)
		else
			billboard_size(icon_size)
		end
	end)

	return billboard {
		size = billboard_size,
		max_distance = 30,
		adornee = adornee,
		-- proximityprompt {
		-- 	frame {
		-- 		size = UDim2.new(1, 0, 1, 0),
		-- 		color = Color3.fromRGB(255, 0, 0),
		-- 	},
		-- },
		show(display_proximity, function()
			return Proximity {
				action = action,
				actionkey = "E",
				proximitytext = text,
			}
		end, function()
			return ProximityDistanceIcon {
				rotation = 0, -- this actually needs to be changed depending on how close our playeur is
				inverted = true,
				icon = fallback_icon,
			}
		end),
	}
end

return DoorProximity
