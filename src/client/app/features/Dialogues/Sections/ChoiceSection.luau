local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserChoices = require(ReplicatedStorage.client.app.features.Dialogues.UserChoices)
local assets = require(ReplicatedStorage.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local ratio = require(ReplicatedStorage.client.app.components.ratio)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local viewport = require(ReplicatedStorage.client.app.components.viewport)

local create = vide.create
local changed = vide.changed
local effect = vide.effect
local cleanup = vide.cleanup
local source = vide.source
local px = use_px.px

--[[

  - render the choices
  - render the viewport model
  - render the stripe images around the viewport model
  - animate those stripe when mount/unmount

  - later enhancements to do
  - effects around bottom left and top right corner, maybe some kind of constantly moving tile
  - mount / unmount animations

]]

local function LongStripe(props)
	local longstripe = assets.images["ArtStripe1.svg"]

	return create "ImageLabel" {
		Image = longstripe,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),

		ratio {
			ratio = 500 / 1440,
		},
	}
end

local function ShortStripe(props)
	local shortstripe = assets.images["ArtStripe2.svg"]

	return create "ImageLabel" {
		Image = shortstripe,
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),

		ratio {
			ratio = 400 / 500,
		},
	}
end

type props = {
	choices: types.Source<{ types.DialogueType }>,
	mycharacter: Model,
}

local function model_y_size(model: Model)
	--TODO, we want to make this function general for all character kinds
	-- right now im just doing a hacky way, where i grab the HumanoidRootPar Y size and the
	-- offset vector from the ground and add them up. This is bad though as R6 uses Head as
	-- root part, which just messes up everything
	-- assume that the model CFrame is 0, 0, 0?

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	assert(humanoid, `Currently the height of the model only supports for characters`)

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		local hrp = model.PrimaryPart
		assert(hrp ~= nil, "HumanoidRootPart must exist")

		local y_size = hrp.Size.Y
		-- local hip_height = humanoid.HipHeight
		local hip_height = hrp.Position.Y

		return y_size + hip_height + 1
	else
		-- assume it is R6
		local head = model:FindFirstChild("Head") :: Part
		local torso = model:FindFirstChild("Torso") :: Part
		local leftleg = model:FindFirstChild("Left Leg") :: Part
		assert(head and torso and leftleg, `R6 character must have head, torso and left leg`)

		return head.Size.Y + torso.Size.Y + leftleg.Size.Y
	end
end

local function fit_to_viewport(viewportsize: Vector2, model: Model, camera: Camera?)
	local char_height = model_y_size(model)
	local fov = if camera then camera.FieldOfView else 70

	local fov_rad = math.rad(fov / 2)
	local depth = (char_height / (math.tan(fov_rad) * 2))

	return depth
end

local function is_valid_accessory(accessory: Accessory)
	local handle = accessory:FindFirstChild("Handle")
	if not handle then
		return false
	end

	local found = handle:FindFirstChild("HatAttachment") or handle:FindFirstChild("HairAttachment")
	return if found then true else false
end

local function ChoiceSection(props: props)
	local dialogue_choices = props.choices
	local viewport_sz = source(Vector2.new())
	local character = props.mycharacter:Clone()

	cleanup(function()
		if character then
			character:Destroy()
		end
	end)
	-- character:MoveTo(Vector3.zero)

	task.spawn(function()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local bodycolors = character:FindFirstChildOfClass("BodyColors")
		if humanoid ~= nil then
			local store = {}
			for _, accessory in character:GetChildren() do
				if not accessory:IsA("Accessory") then
					continue
				end

				if is_valid_accessory(accessory) then
					table.insert(store, accessory:Clone())
				end
			end

			humanoid:RemoveAccessories()
			for _, accessory in store do
				humanoid:AddAccessory(accessory)
			end
		end
		if bodycolors ~= nil then
			bodycolors.LeftArmColor3 = Color3.fromRGB()
			bodycolors.RightArmColor3 = Color3.fromRGB()
			bodycolors.LeftLegColor3 = Color3.fromRGB()
			bodycolors.RightLegColor3 = Color3.fromRGB()
			bodycolors.TorsoColor3 = Color3.fromRGB()
		end
	end)

	return {
		pane {
			name = "avatar-section",
			size = UDim2.new(0.5, 0, 1, 0),
			color = Color3.fromRGB(255, 0, 0),
			pos = UDim2.new(1, 0, 0, 0),
			anchor = Vector2.new(1, 0),

			frame {
				transparency = 0,
				color = Color3.fromRGB(0, 0, 0),
				size = function()
					return UDim2.new(0, px(1000), 0, px(1440))
				end,
				rotation = 15,
			},
			viewport {
				changed("AbsoluteSize", viewport_sz),
				size = UDim2.new(1, 0, 0, px(700)),
				pos = UDim2.new(1, 0, 0.2, 0),
				anchor = Vector2.new(1, 0),
				model = character,
				-- transform = CFrame.new(0, 0, -4) * CFrame.Angles(0, math.rad(180) + math.rad(20), 0),
				-- camera_position = (CFrame.Angles(0, math.rad(20), 0) * CFrame.Angles(0, 0, math.rad(-5)))
				-- 	* CFrame.new(-0.2, -0.5, 3),
				transform = function()
					return CFrame.new(0, 0, 0)
				end,
				camera_position = function()
					-- local root = props.mycharacter.PrimaryPart :: Part
					local viewport = viewport_sz()
					local depth = fit_to_viewport(viewport, character)
					--//TODO : we might need to do some weird hack for this...

					-- return CFrame.new(0, depth, 0)
					-- 	* CFrame.Angles(0, math.rad(180) + math.rad(15), 0)
					-- 	* CFrame.Angles(0, 0, -math.rad(10))
					-- 	* CFrame.new(0, 0, depth / 2)

					return CFrame.new(0, 1, 0)
						* CFrame.Angles(0, math.rad(180) + math.rad(15), 0)
						* CFrame.Angles(0, 0, -math.rad(10))
						* CFrame.new(0, 0, 2.5)
				end,
			},
			LongStripe {},
			ShortStripe {},
		},
		pane {
			name = "choices-section",
			size = UDim2.new(0.6, 0, 1, 0),
			color = Color3.fromRGB(0, 255, 0),

			pane {
				size = UDim2.new(1, 0, 0.5, 0),
				pos = UDim2.new(1, 0, 1, 0),
				anchor = Vector2.new(1, 1),
				zindex = 3,
				UserChoices {
					choices = dialogue_choices,
				},
			},
		},
	}
end

return ChoiceSection
