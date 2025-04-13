local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)

local function pose_select(props)
	local black = Color3.fromRGB(60, 60, 60)
	local text_color = function()
		return Color3.fromRGB(255, 255, 150)
	end

	return {
		frame {
			transparency = 0.05,
			color = function()
				return black
			end,
			rotation = 5,
			rtext {
				text = function()
					return `[E]: Confirm Pose?`
				end,
				bolded = true,
				italic = true,
				size = "sm",
				color = text_color,
				wrap = true,
			},
		},
	}
end

return pose_select
