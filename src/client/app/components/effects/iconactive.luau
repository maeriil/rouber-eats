local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
type props = {

	[number]: any,
}

print("TODO: Work on the dotted effect ui, which is used for all icon buttons on active")

local action = vide.action
local cleanup = vide.cleanup
local source = vide.source
local spring = vide.spring

local function dot(props: {
	size: can<UDim2>,
	pos: can<UDim2>,
})
	return frame {
		color = Color3.fromRGB(),
		size = props.size,
		pos = props.pos,
		anchor = Vector2.new(0.5, 0.5),
		circle {},
	}
end

local function icon_active_effect(props: props)
	local dots = {}

	local t = source(0)
	local speed = 10
	local rot = spring(function()
		return (t() * speed) % 360
	end, 0.15)
	local n = 32
	local r = source(96)

	--//TODO: Honestly we should just upload an image of dotted like honkai star rail does
	-- its gonna look a lot more smoother than right now because each individual circle moves weirdly due to how pixels work
	for i = 1, n do
		local angle = (i / n) * (math.pi * 2)
		local x = math.cos(angle) * r()
		local y = math.sin(angle) * r()

		table.insert(
			dots,
			dot({
				size = UDim2.new(0, 4, 0, 4),
				pos = UDim2.new(0.5, x, 0.5, y),
			})
		)
	end

	cleanup(RunService.Heartbeat:Connect(function(dt: number)
		local new_t = t() + dt
		t(new_t)
	end))

	return pane {
		rotation = function()
			return rot()
		end,
		size = UDim2.new(1, 0, 1, 0),
		circle {},
		dots,

		action(function(frame: Frame)
			r(frame.AbsoluteSize.X // 2)
		end),

		unpack(props),
	}
end

return icon_active_effect
