local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)

local px = use_px.px
local create = vide.create
local source = vide.source
local action = vide.action
local cleanup = vide.cleanup
local effect = vide.effect
local untrack = vide.untrack

local function pose_select_text_msg(props)
	local pose_font_color = Color3.fromRGB(255, 0, 0)
	return pane {
		size = function()
			return UDim2.new(1, 0, 0, px(48))
		end,
		pos = function()
			return UDim2.new(0.5, 0, 1, 0)
		end,
		anchor = function()
			return Vector2.new(0.5, 1)
		end,
		rtext {
			text = function()
				return `What <b><font color="#{pose_font_color:ToHex()}">Pose</font></b> do you want to select?`
			end,
			size = "sm",
			xalign = Enum.TextXAlignment.Left,
			italic = true,
		},
	}
end

-- --//TODO: we should replace the old viewport component with the new one?
type viewportprops = {
	model: types.Source<Model>,
	model_pos: () -> CFrame,
	cam_pos: () -> CFrame,
	anim_track: types.Source<AnimationTrack>,
}
local function viewport(props: viewportprops)
	local camera = source() :: types.Source<Camera>
	local model = source(props.model():Clone())

	return create "ViewportFrame" {
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(0, 0, 255),
		CurrentCamera = camera,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,

		create "WorldModel" {
			action(function(_world_model: Instance)
				local world_model = _world_model :: WorldModel
				local m = model()
				m:PivotTo(props.model_pos())
				m.Parent = world_model
				world_model.PrimaryPart = m.PrimaryPart

				-- local track = props.anim_track()
				-- track:Play()

				return cleanup(model)
			end),

			-- LevelOfDetail = Enum.ModelLevelOfDetail.Automatic,
			-- ModelStreamingMode = Enum.ModelStreamingMode.Default,
		},

		create "Camera" {
			CFrame = props.cam_pos,
			action(function(_c: Instance)
				local cam = _c :: Camera
				camera(cam)
			end),
		},
	}
end

local function pose_title_name(props: {
	name: () -> string,
})
	local text_color = function()
		-- return Color3.fromRGB(255, 255, 150)
		return Color3.fromRGB(0, 100, 200)
	end

	return pane {
		size = function()
			return UDim2.new(0.75, 0, 0.45, 0)
		end,
		pos = function()
			return UDim2.new(0.5, 0, 0.75, 0)
		end,
		anchor = Vector2.new(0.5, 0.75),

		rtext {
			text = props.name,
			xbolded = true,
			wrap = true,
			italic = true,
			size = "lg",
			ttransparency = 0.45,
			color = text_color,
		},
	}
end

type props = {
	model: types.Source<Model>,
	animation_to_play: types.Source<Animation>,
	pose: () -> string,
}

local function pose_viewport(props: props): { any }
	local track_render = source() :: types.Source<AnimationTrack>

	effect(function()
		local m = props.model()
		local humanoid = m:FindFirstChildOfClass("Humanoid")
		assert(humanoid ~= nil, `Viewport model must have a valid humanoid`)

		local animator = humanoid:FindFirstChildOfClass("Animator")
		assert(animator ~= nil, `Humanoid must have a valid animator instance to render animation`)

		local curr_track = untrack(track_render)
		if curr_track then
			curr_track:Stop()
			curr_track:Destroy()
		end

		print("updating track...")
		local track_to_play = props.animation_to_play()
		local track = animator:LoadAnimation(track_to_play)
		track.Looped = true
		track:Play() -- no idea if we should be able to play it here...?
		track_render(track)
	end)

	return {

		viewport {
			model = props.model,
			cam_pos = function()
				return CFrame.new(0, 0.25, 0)
					* CFrame.Angles(0, math.rad(180 + 25), 0)
					* CFrame.Angles(math.rad(-15), 0, 0)
					* CFrame.new(0, 2.5, 6)
			end,
			model_pos = function()
				return CFrame.new()
			end,
			anim_track = track_render,
		},
		pose_title_name {
			name = props.pose,
		},
		pose_select_text_msg {},
	}
end

return pose_viewport
