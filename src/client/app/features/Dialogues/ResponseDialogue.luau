local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueAuthor = require(script.Parent.DialogueAuthor)
local DialogueIndicator = require(script.Parent.DialogueIndicator)
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local ratio = require(ReplicatedStorage.client.app.components.ratio)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create
local effect = vide.effect
local read = vide.read
local source = vide.source
local show = vide.show

type props = {
	order: types.Can<number>?,
	click: () -> (),
	disable: types.Can<boolean>?,
	text: types.Can<string>,
	animate: types.Source<boolean>,
	author: types.Can<string>,
	pos: types.Can<UDim2>?,
	anchor: types.Can<Vector2>?,
}

local function ResponseDialogue(props: props)
	local scaletween, motion = use_motion(1)
	local text = source("")
	local completed = source(false)

	effect(function()
		if props.animate() then
			print("animating again...")
			completed(false)
			task.spawn(function()
				props.animate(false)
				local final_text = read(props.text)
				for i = 1, final_text:len() do
					text(final_text:sub(1, i))
					task.wait(0.01)
				end
				completed(true)
			end)
		end
	end)

	effect(function()
		if completed() then
			motion:tween(1.5, {
				delayTime = 0,
				direction = Enum.EasingDirection.Out,
				repeatCount = -1,
				reverses = true,
				style = Enum.EasingStyle.Exponential,
				time = 0.2,
			})
		else
			motion:tween(1, {})
		end
	end)

	return pane {
		size = function()
			-- return UDim2.new(0, px(711), 0, px(176))
			return UDim2.new(1, 0, 1, 0)
		end,
		anchor = props.anchor or Vector2.new(0.5, 0.5),
		pos = props.pos or UDim2.new(0.5, 0, 0.5, 0),
		ratio {
			ratio = 711 / 176,
		},
		order = props.order,
		basebutton {
			click = props.click,
			disabled = function()
				return not completed()
			end,
		},
		create "ImageLabel" {
			-- Size = UDim2.new(0, px(711), 0, px(176)),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, -px(32), 0.5, 0),
			Image = assets.images["Dialogue.svg"],
			padding {
				x = padding_types.px36,
				y = padding_types.px16,
			},
			pane {
				size = function()
					return UDim2.fromScale(0.95, 0.8)
				end,
				anchor = Vector2.new(1, 0),
				pos = UDim2.fromScale(1, 0),

				par {
					text = function()
						return text_sizes.bolded(text())
					end,
					color = Color3.fromRGB(255, 255, 255),
					size = function()
						return px(text_sizes.heading.h4)
					end,
					wrap = true,
					xalign = Enum.TextXAlignment.Center,
				},
			},
			show(completed, function()
				return pane {
					size = function()
						return UDim2.fromOffset(px(32), px(32))
					end,
					pos = function()
						return UDim2.new(0.9, 0, 1, 0)
					end,
					anchor = function()
						return Vector2.new(0.9, 1)
					end,
					DialogueIndicator {
						size = function()
							return UDim2.fromOffset(px(30), px(20))
						end,
						scale = scaletween,
					},
				}
			end),
		},

		DialogueAuthor {
			pos = function()
				return UDim2.new(1, 0, 0, -px(48))
			end,
			anchor = Vector2.new(1, 0),
			author = props.author,
		},
	}
end

return ResponseDialogue
