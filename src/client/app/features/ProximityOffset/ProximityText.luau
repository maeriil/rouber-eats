local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local assets = require(ReplicatedStorage.assets)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local ratio = require(ReplicatedStorage.client.app.components.ratio)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type props = {
	text: types.Can<string>,
	rotation: types.Can<number>?,
}

local px = use_px.px
local create = vide.create
local source = vide.source
local cleanup = vide.cleanup
local read = vide.read

type parallelogram_props = {
	color: Color3,
	visible: types.Can<boolean>,
	order: types.Can<number>,
	right: boolean?,
	transparency: types.Can<number>?,
}

local function Parallelogram(props: parallelogram_props)
	local image = if props.right
		then assets.images["ParallelogramRight.svg"]
		else assets.images["ParallelogramLeft.svg"]

	return create "ImageLabel" {
		Image = image,
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		ImageTransparency = props.transparency or 0,
		LayoutOrder = props.order,
		BackgroundTransparency = 1,
		ImageColor3 = props.color or Color3.fromRGB(),
		Visible = props.visible,
		ratio {
			ratio = 0.25,
		},
	}
end

local function ProximityText(props: props)
	local order = next_order()
	local tilt = source(false)
	local t = source(0)
	local speed = 1.05

	cleanup(RunService.Heartbeat:Connect(function(dt: number)
		local curr = dt + t() * speed
		if curr >= 1 then
			curr = 0
			tilt(not tilt())
		end
		t(curr)
	end))

	return frame {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		rotation = props.rotation,
		-- padding {
		-- 	padding = padding_types.px4,
		-- },
		pane {
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			pos = function()
				return UDim2.new(0, px(16 / 2), 0, 0)
			end,
			pane {
				size = UDim2.new(1, 0, 1, 0),
				hlayout {
					pad = padding_types.nopad,
				},

				frame {
					order = order(),
					visible = function()
						return not tilt()
					end,
					size = function()
						return UDim2.new(1, 0, 1, 0)
					end,
					flexfill {},
					color = Color3.fromRGB(0, 0, 0),
				},
				Parallelogram {
					order = order(),
					visible = true,
					right = true,
					color = Color3.fromRGB(255, 0, 0),
					transparency = 1,
				},
			},
			pane {
				size = UDim2.new(1, 0, 1, 0),
				hlayout {
					pad = padding_types.nopad,
				},
				Parallelogram {
					order = order(),
					visible = tilt,
					color = Color3.fromRGB(),
				},
				frame {
					size = function()
						return UDim2.new(1, 0, 1, 0)
					end,
					flexfill {},
					visible = tilt,
					order = order(),
					color = Color3.fromRGB(),
				},
				Parallelogram {
					order = order(),
					visible = tilt,
					right = true,
					color = Color3.fromRGB(),
				},
			},
			pane {
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				-- padding {
				-- 	x = padding_types.px32,
				-- 	y = padding_types.px4,
				-- },
				par {
					text = function()
						return text_sizes.bolded(read(props.text))
					end,
					xalign = Enum.TextXAlignment.Center,
					color = Color3.fromRGB(255, 255, 255),
					size = function()
						return px(36)
					end,
				},
			},
		},
	}
end

return ProximityText
