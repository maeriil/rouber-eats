local ReplicatedStorage = game:GetService("ReplicatedStorage")
local billboard = require(ReplicatedStorage.client.app.components.billboard)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local t = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local derive = vide.derive
local create = vide.create

type props = {
	details: t.Source<t.MailboxProximityDetails>,
}

local function MailboxProximity(props: props)
	local details = derive(props.details)
	local adornee = function()
		return details().adornee
	end

	local function adjust_offset()
		return vector.create(0, -5, 0)
	end

	return billboard {
		adornee = adornee,
		max_distance = 75,
		offset = adjust_offset,
		size = function()
			return UDim2.new(8, 0, 4, 0)
		end,

		frame {
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			transparency = 0.5,
			create "TextLabel" {
				RichText = true,
				Text = function()
					return `<b>{details().owner_text}</b>`
				end,
				Size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				BackgroundTransparency = 1,
				TextScaled = true,
			},
		},
	}
end

return MailboxProximity
