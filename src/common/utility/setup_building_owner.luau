local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local pair = jecs.pair

local function setup_npc(model: Model)
	local hrp = model.PrimaryPart
	local humanoid = model:FindFirstChildOfClass("Humanoid")

	assert(hrp, `Humanoid root part must exist for the npc {model.Name}`)
	assert(humanoid, `Humanoid must exist for the npc {model.Name}`)

	local animator = humanoid:FindFirstChildOfClass("Animator")
	assert(animator, `Animator must exist for the npc {model.Name}`)

	local e = ref(model)

	world:add(e, c.NPC)
	world:set(e, c.Model, model)
	world:set(e, c.PrimaryPart, hrp)
	world:set(e, c.Humanoid, humanoid)
	world:set(e, c.Animator, animator)

	return e
end

local function setup_building_owner(building: Model, owner: Model)
	local owner_id = setup_npc(owner)
	local building_id = ref(building)

	world:add(building_id, pair(c.OwnedBy, owner_id))
	world:add(owner_id, pair(c.OwnsBuilding, building_id))
end

return setup_building_owner
