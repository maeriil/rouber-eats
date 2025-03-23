local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local textstroke = require(ReplicatedStorage.client.app.components.border.textstroke)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local px = use_px.px
local read = vide.read
local source = vide.source

type props = {
	text: string,
	effecttype: ((number, number) -> number)?,
	rotation: types.Can<number>?,
	mainsize: types.Can<number>?,
	pos: types.Can<UDim2>?,
	anchor: types.Can<Vector2>?,
	scale: types.Can<number>?,
}

local function inverseRootSize(baseSize: number, index: number)
	return baseSize / math.sqrt(index)
end

function get_letter_size(letter: string, font: Enum.Font, size: number)
	local textBounds =
		TextService:GetTextSize(letter, size, font, Vector2.new(math.huge, math.huge))
	return textBounds.X -- Width of the letter
end

local function another_get_letter_size(letter: string, font: Font, size: number)
	local params = Instance.new("GetTextBoundsParams")
	params.Font = font
	params.Text = letter
	params.Size = size
	params.Width = 1000

	local bounds = TextService:GetTextBoundsAsync(params)

	return bounds.X
end

-- DOUBLE STROKE EFFECT
local function LetterEffect(props: {
	letter: types.Can<string>,
	rotation: types.Can<number>?,
	order: types.Can<number>?,
	textsize: types.Can<number>?,
})
	-- monotone
	-- irish grover
	-- akronim

	local font = Font.fromId(12187376910, Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)
	-- local basefont = Enum.Font.Kalam
	-- local frame_x_size = get_letter_size(read(props.letter), basefont, read(props.textsize))
	local letter = read(props.letter)
	local textsize = read(props.textsize)
	-- local frame_inside_x_size = another_get_letter_size(letter, font, textsize)
	local stroke = 6
	-- local frame_outside_x_size =
	-- 	another_get_letter_size(letter, font, textsize + stroke * 2)

	-- local bounds = source(0)
	-- bounds(another_get)

	local frame_inside_x_size = source(0)
	local frame_outside_x_size = source(0)

	task.spawn(function()
		frame_inside_x_size(another_get_letter_size(letter, font, textsize))
		frame_outside_x_size(another_get_letter_size(letter, font, textsize + stroke * 2))
	end)

	return create "TextLabel" {
		TextColor3 = Color3.fromRGB(255, 255, 255),
		LayoutOrder = props.order,
		-- RichText = true,
		-- Text = text_sizes.bolded(read(props.letter)),
		Text = props.letter,
		Size = function()
			return UDim2.new(0, frame_outside_x_size() + stroke, 1, 0)
		end,
		TextSize = function()
			return textsize + stroke
		end,
		-- FontFace = Font.fromEnum(basefont),
		Rotation = props.rotation,
		FontFace = font,
		BackgroundTransparency = 1,
		textstroke {
			color = Color3.fromRGB(),
			thickness = function()
				return px(12)
			end,
		},

		create "TextLabel" {
			LayoutOrder = props.order,
			RichText = true,
			Text = text_sizes.bolded(read(props.letter)),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = function()
				return UDim2.new(0, frame_inside_x_size() + stroke / 2, 1, 0)
			end,
			TextSize = props.textsize,
			-- FontFace = Font.fromEnum(basefont),
			FontFace = font,
			BackgroundTransparency = 1,
			textstroke {
				color = Color3.fromRGB(255, 255, 255),
				thickness = function()
					return px(stroke)
				end,
			},
		},
	}
end

-- local function LetterEffect(props: {
-- 	letter: types.Can<string>,
-- 	rotation: types.Can<number>?,
-- 	order: types.Can<number>?,
-- 	textsize: types.Can<number>?,
-- })
-- 	-- monotone
-- 	-- irish grover
-- 	-- akronim

-- 	local font = Font.fromId(12187376910, Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)
-- 	-- local basefont = Enum.Font.Kalam
-- 	-- local frame_x_size = get_letter_size(read(props.letter), basefont, read(props.textsize))
-- 	local letter = read(props.letter)
-- 	local textsize = read(props.textsize)
-- 	local frame_inside_x_size = another_get_letter_size(letter, font, textsize)
-- 	local stroke = 6

-- 	return create "TextLabel" {
-- 		TextColor3 = Color3.fromRGB(0, 0, 0),
-- 		LayoutOrder = props.order,
-- 		-- RichText = true,
-- 		-- Text = text_sizes.bolded(read(props.letter)),
-- 		Text = props.letter,
-- 		Size = function()
-- 			return UDim2.new(0, frame_inside_x_size + stroke / 2, 1, 0)
-- 		end,
-- 		TextSize = function()
-- 			return textsize
-- 		end,
-- 		-- FontFace = Font.fromEnum(basefont),
-- 		FontFace = font,
-- 		BackgroundTransparency = 1,
-- 		textstroke {
-- 			color = Color3.fromRGB(255, 255, 255),
-- 			thickness = function()
-- 				return stroke
-- 			end,
-- 		},
-- 	}
-- end

local function ProximityActionName(props: props)
	local container = {}
	local text = props.text
	local mainsize = props.mainsize or 108
	local effecttype = props.effecttype or inverseRootSize

	for i = 1, #props.text do
		local curr = text:sub(i, i)
		table.insert(
			container,
			LetterEffect {
				letter = curr,
				order = i,
				rotation = math.random(0, 10),
				textsize = function()
					-- return logSize(mainsize, i)
					-- return waveSize(mainsize, i)
					return effecttype(read(mainsize), i)
				end,
			}
		)
	end

	return pane {
		pos = props.pos,
		anchor = props.anchor,
		size = function()
			return UDim2.new(0, px(200), 0, px(50))
		end,
		-- size = function()
		-- 	return UDim2.new(1, 0, 1, 0)
		-- end,
		rotation = props.rotation,
		hlayout {
			pad = padding_types.nopad,
		},
		container,

		create "UIScale" {
			Scale = props.scale,
		},
	}
end

return ProximityActionName
