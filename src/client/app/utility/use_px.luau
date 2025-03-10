local ReplicatedStorage = game:GetService("ReplicatedStorage")
local useEventListener = require(script.Parent.use_eventlistener)
local vide = require(ReplicatedStorage.pkg.vide)

local source = vide.source

--[=[
    Base resolution is the resolution we use to create our stories. By default, we should
    probably use 1920x1080 but this might be something worth changing?
]=]
local BASE_RESOLUTION = Vector2.new(1280, 832)

--//TODO: Document this
local MIN_SCALE = 0.5

--//TODO: Document this
local DOMINANT_AXIS = 0.5
local scale = source(1)

local px = setmetatable(
	{
		even = function(value: number)
			return math.round(value * scale() * 0.5) * 2
		end,
		scale = function(value: number)
			return value * scale()
		end,
		floor = function(value: number)
			return math.floor(value * scale())
		end,
		ceil = function(value: number)
			return math.ceil(value * scale())
		end,
	} :: any,
	{
		__call = function(_, value: number)
			return math.round(value * scale())
		end,
	}
) :: ((number) -> number) & {
	even: (number) -> number,
	scale: (number) -> number,
	floor: (number) -> number,
	ceil: (number) -> number,
}

local function use_px()
	local camera = workspace.CurrentCamera
	assert(camera ~= nil, "Current camera cannot be nil")

	local function update_scale()
		local width = math.log(camera.ViewportSize.X / BASE_RESOLUTION.X, 2)
		local height = math.log(camera.ViewportSize.Y / BASE_RESOLUTION.Y, 2)
		local centered = width + (height - width) * DOMINANT_AXIS

		local final = math.max(math.pow(2, centered), MIN_SCALE)
		scale(final)
	end

	useEventListener(camera:GetPropertyChangedSignal("ViewportSize"), function(a0)
		update_scale()
	end)

	update_scale()
end

return {
	px = px,
	use_px = use_px,
}
