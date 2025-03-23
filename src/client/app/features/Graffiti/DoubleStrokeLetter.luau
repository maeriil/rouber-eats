local ReplicatedStorage = game:GetService("ReplicatedStorage")
local graffiti = require(ReplicatedStorage.common.configs.gamefont.graffiti)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create

local function DoubleStrokeLetter(props: {
	letter: string,
	order: number,
	size: types.Can<UDim2>,
	rotation: types.Can<number>,
	position: types.Can<UDim2>?,
	anchor: types.Can<Vector2>?,
	inverted: boolean?,
})
	local font = graffiti.font
	local outercolor = if props.inverted then "#fff" else "#000"
	local innercolor = if props.inverted then "#000" else "#fff"
	local thickness = 4

	local inner_text = function()
		return `<stroke color="#{innercolor}" joins="round" thickness="{thickness}" transparency="0"><b><font color="#{outercolor}">{props.letter}</font></b></stroke>`
	end
	local outer_text = function()
		return `<stroke color="{outercolor}" joins="round" thickness="{thickness * 2}" transparency="0"><b><font color="{outercolor}">{props.letter}</font></b></stroke>`
	end

	return pane {
		size = props.size,
		order = props.order,
		create "TextLabel" {
			Rotation = props.rotation,
			BackgroundTransparency = 1,
			Name = "Outer",
			RichText = true,
			FontFace = font,
			Text = outer_text,
			Size = function()
				return UDim2.new(0.95, 0, 0.95, 0)
			end,
			Position = props.position or UDim2.fromScale(0.5, 0.5),
			AnchorPoint = props.anchor or Vector2.new(0.5, 0.5),
			TextScaled = true,

			create "TextLabel" {
				BackgroundTransparency = 1,
				Name = "Inner",
				RichText = true,
				FontFace = font,
				Text = inner_text,
				Size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				Position = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				AnchorPoint = Vector2.new(0.5, 0.5),
				TextScaled = true,
			},
		},
	}
end

return DoubleStrokeLetter
