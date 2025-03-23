local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local source = vide.source
local changed = vide.changed
local read = vide.read
local px = use_px.px

-- #1 thing is that we cannot use offset
-- If we cannot use offset, then we need another way to size the text
-- We also must use TextScaled for every letter otherwise PX will cause it to grow bigger as u zoom out
-- This includes for things like padding too. Super annoying

local function another_get_letter_size(letter: string, font: Font, size: number)
	local params = Instance.new("GetTextBoundsParams")
	params.Font = font
	params.Text = letter
	params.Size = size
	params.Width = 1000

	local bounds = TextService:GetTextBoundsAsync(params)

	return bounds.X
end

local function DoubleStrokeLetter(props: {
	letter: string,
	order: number,
	size: types.Can<UDim2>,
	rotation: types.Can<number>,
	position: types.Can<UDim2>?,
})
	local font = Font.fromId(12187376910, Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)
	local inner_text = function()
		return `<stroke color="#fff" joins="round" thickness="4" transparency="0"><b><font color="#000">{props.letter}</font></b></stroke>`
	end
	local outer_text = function()
		return `<stroke color="#000" joins="round" thickness="4" transparency="0"><b><font color="#000">{props.letter}</font></b></stroke>`
	end

	return pane {
		-- size = UDim2.new(0.15, 0, 0.8, 0),
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
				return UDim2.new(0.9, 0, 0.9, 0)
			end,
			-- Position = function()
			-- 	return UDim2.new(0.5, 0, 0.5, 0)
			-- end,
			Position = props.position,
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextScaled = true,

			create "TextLabel" {
				BackgroundTransparency = 1,
				Name = "Inner",
				RichText = true,
				FontFace = font,
				Text = inner_text,
				Size = function()
					return UDim2.new(0.85, 0, 0.85, 0)
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

type props = {
	text: string,
	-- basetextsize: number,
	rotation: types.Can<number>?,
}

local function baseSize(totalChars: number): number
	return 1 / totalChars
end

-- 4️⃣ Exponential Decay (Starts Big, Gets Smaller)
local function expDecaySize(index: number, totalChars: number): number
	local maxSize = baseSize(totalChars)
	return maxSize * math.exp(-index / totalChars)
end

-- 6️⃣ Inverse Root Size (Big at Start, Drops Off Slower)
local function inverseRootSize(index: number, totalChars: number): number
	local maxSize = baseSize(totalChars)
	return maxSize * (1 / math.sqrt(index + 1))
end

-- 1️⃣ Smooth Wave Effect (Sin + Soft Variations)
local function smoothWaveSize(index: number, totalChars: number): number
	local maxSize = baseSize(totalChars)
	return maxSize * (0.8 + 0.2 * math.sin(index / totalChars * math.pi * 3))
end

-- 2️⃣ Noise Wave Effect (Smooth Randomness)
local function noiseWaveSize(index: number, totalChars: number): number
	local maxSize = baseSize(totalChars)
	return maxSize * (0.8 + 0.2 * math.sin(index * 1.5) * math.cos(index * 0.7))
end

-- 1️⃣ Graffiti Size Variation
local function graffitiSize(index: number, totalChars: number): number
	local maxSize = baseSize(totalChars)

	-- Layered wave effects for smooth scaling
	return maxSize
		* (
			0.85
			+ 0.15 * math.sin(index / totalChars * math.pi * 2)
			+ 0.08 * math.cos(index * 1.3)
		)
end

local function graffitiSize2(index: number, totalChars: number): number
	local baseScale = 1 / totalChars -- Base size scaling

	-- Wave effects for smooth, natural variation
	local sizeFactor = (
		0.8
		+ 0.2 * math.sin(index / totalChars * math.pi * 2)
		+ 0.1 * math.cos(index * 1.3)
	)

	-- Reduce horizontal size slightly (brings letters closer)
	local horizontalCompression = 0.9 -- Lower value = tighter spacing

	return baseScale * sizeFactor * horizontalCompression
end

-- 2️⃣ Smooth Rotation Effect
local function graffitiRotation(index: number, maxRotation: number): number
	-- Only rotate some letters, not all (ensures natural variation)
	if index % 2 == 0 then
		return 0 -- Some letters remain upright
	end

	-- Layered wave for smooth rotation variation
	return maxRotation * (0.6 * math.sin(index * 1.2) + 0.4 * math.cos(index * 0.9))
end

local function getLetterSpacing(index: number, totalChars: number): number
	local baseSpacing = 1 / totalChars -- Default spacing

	-- Reduce spacing dynamically based on letter size
	local compressionFactor = 0.85 -- Lower = more overlap

	return baseSpacing * compressionFactor
end

local function GraffitiStylizedText(props: props)
	local text = props.text
	local textsize = text:len()

	local letters = {}
	-- local scales = generateGraffitiScales(props.text)

	for i = 1, #text do
		local current_letter = text:sub(i, i)
		local scale_sz = graffitiSize2(i, textsize)
		local rotation = graffitiRotation(i, 6)
		local letter_offset = getLetterSpacing(i, textsize)

		table.insert(
			letters,
			DoubleStrokeLetter {
				letter = current_letter,
				order = i,
				size = UDim2.new(scale_sz, 0, 1, 0),
				rotation = rotation,
				position = UDim2.new(0.5 - letter_offset, 0, 0.5, 0),
			}
		)
	end

	return pane {
		size = UDim2.new(1, 0, 1, 0),
		rotation = props.rotation,
		hlayout {
			pad = padding_types.nopad,
		},
		letters,
	}
end

return GraffitiStylizedText
