local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local source = vide.source
local cleanup = vide.cleanup
local action = vide.action
local create = vide.create
local effect = vide.effect
local read = vide.read

type props = {
	model: Model,
	transform: types.Can<CFrame>?,
	camera_position: types.Can<CFrame>?,
	size: types.Can<UDim2>?,
	pos: types.Can<UDim2>?,
	anchor: types.Can<Vector2>?,
	rotation: types.Can<number>?,
}

local function viewport(props: props)
	local camera = source(nil)
	local model = props.model:Clone()
	-- local transform = props.transform
	-- 	or CFrame.new(-0.5, -0, 0) * (CFrame.Angles(0, math.rad(135), 0))
	local transform = props.transform or CFrame.new()
	local camcf = props.camera_position or CFrame.new()

	return create "ViewportFrame" {
		unpack(props),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(0, 0, 255),
		CurrentCamera = camera,
		Position = props.pos,
		AnchorPoint = props.anchor,
		Size = props.size or function()
			return UDim2.new(1, 0, 1, 0)
		end,
		Rotation = props.rotation,
		action(function(frame: Instance)
			assert(frame:IsA("ViewportFrame"))
			model:PivotTo(read(transform))
			model.Parent = frame

			return cleanup(model)
		end),
		create "Camera" {
			CFrame = camcf,
			action(function(c: Instance)
				assert(c:IsA("Camera"))
				camera(c :: never)
			end),
		},
	}
end

return viewport
