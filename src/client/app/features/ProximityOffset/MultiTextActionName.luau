local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ActionName = require(script.Parent.ActionName)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local interval = require(ReplicatedStorage.common.ecs.interval)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local cleanup = vide.cleanup
local source = vide.source
local spring = vide.spring
local read = vide.read

type props = {
	text: { string },
	effecttype: ((number, number) -> number)?,
	mainsize: types.Can<number>,
}

local function stylized(props: {
	effect: (number, number) -> number,
	text: string,
	rotation: types.Can<number>,
	order: types.Can<number>,
	mainsize: types.Can<number>,
})
	return pane {
		order = props.order,
		size = function()
			return UDim2.new(0, 200, 0, 80)
		end,
		ActionName {
			effecttype = props.effect,
			text = props.text,
			rotation = props.rotation,
			mainsize = props.mainsize,
		},
	}
end

local function inverseZigzagSize(baseSize: number, index: number)
	local base = baseSize / math.sqrt(index)
	local spike = (index % 2 == 0) and 1.2 or 0.8 -- Alternate size bumps
	return base * spike
end

local function MultiTextAction(props: props)
	local container = {}
	local max_threshold = 3
	local rot = source(max_threshold)
	local spring_rot = spring(rot, 0.6)
	local every = interval(0.5)

	cleanup(RunService.Heartbeat:Connect(function(dt: number)
		if every() then rot(-rot()) end
	end))

	local n = #props.text
	for i, str in props.text do
		table.insert(
			container,
			stylized {
				effect = props.effecttype or inverseZigzagSize,
				text = str,
				rotation = spring_rot,
				order = i,
				mainsize = props.mainsize,
			}
		)
	end

	return frame {
		size = function()
			return UDim2.new(0, 800, 0, (n * read(props.mainsize)) / 2)
		end,
		vlayout {
			pad = padding_types.nopad,
		},
		container,
	}
end

return MultiTextAction
