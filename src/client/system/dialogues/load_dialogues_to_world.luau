local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basepartmap = require(ReplicatedStorage.client.store.basepartmap)
local basic_convo_1 = require(ReplicatedStorage.common.configs.dialogues.npc.basic_convo_1)
local get_dialogue_configs =
	require(ReplicatedStorage.common.configs.dialogues.get_dialogue_configs)
local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	local instances = CollectionService:GetTagged(tags.Dialogue)

	for _, config_instance in instances do
		-- warn(`Setting up dialogues! yay....`)
		assert(
			config_instance:IsA("Configuration"),
			`Only Configurations must contain the dialogue tag as it contains properties`
		)

		local parent = config_instance:FindFirstAncestorOfClass("Model")
		if parent == nil then
			error(`Configuration object is not a descendant of a model. What should happen in this case?`)
		end

		if ref.contains(parent) then
			continue
		end

		local root = parent.PrimaryPart
		assert(root ~= nil, "Primary part must exist for the model")

		local config = get_dialogue_configs(config_instance)
		local dialogue_id

		-- if config.dialogue_id == "test_dialogue" then
		-- 	dialogue_id = basic_convo_1 {
		-- 		npc = parent,
		-- 	}
		-- end

		--[[
			TODO: this is a hacky way, we need to ensure that we add the NPC models to the
			world BEFORE we attemt to adding their dialogue configuration
			This is beacuse a lof ot he dialgoue depends on the model.

			Actually, the order shouldn't matter as long as we use ref no?
		]]
		local id = ref(parent)
		world:set(id, c.HasDialogue, config)
		world:set(id, c.Model, parent)
		world:set(id, c.PrimaryPart, root)
		-- world:set(id, c.Cleanup, cleanup)

		--[[
			TODO: Something to consider

			Having a general table that holds entity map for all kinds of things can be tricky
			For ex, lets say a door can open/close, but also has dialogue, well, how do we keep track of its
			entity id?

			My solution right now is that in the basepartmap, we store the primary part of the model mapped to its own id
			So in this case we would have [door.PrimaryPart] = door_id

			Then we store all kinds of properties inside the door_id, in our case, the open/close whatever stuff
			as well as dialogue. The only thing is im not sure if we might potentially run into some bugs if we start
			storing some other id map...

		]]
		basepartmap[root] = id
		config_instance:Destroy()
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Client.GeneralSetups.Setup,
	runConditions = {
		-- planck.runOnce(),
	},
}
