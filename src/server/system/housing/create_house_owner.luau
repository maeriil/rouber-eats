-- stylua: ignore start
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local playerdatastore     = require(ServerScriptService.server.store.playerdatastore)
local jecs                = require(ReplicatedStorage.pkg.jecs)
local phases              = require(ReplicatedStorage.common.ecs.phases)

local p                   = require(ReplicatedStorage.common.ecs.pairs)
local c                   = require(ReplicatedStorage.common.ecs.components)
local world               = require(ReplicatedStorage.common.ecs.world)
local t                   = require(ReplicatedStorage.types)
local attributes          = require(ReplicatedStorage.types.attributes)
local tags                = require(ReplicatedStorage.types.tags)
local __                  = jecs.Wildcard

local create_house_owner = world
	:query(p.Create(c.Model), p.EntityId(c.Claimed), c.Name)
	:with(c.HouseOwner)
	:without(p.ModelOf(c.HouseOwner))
	:cached()
-- stylua: ignore end

local function system()
	for id, model, claimed_plot_id, owner_name in create_house_owner:iter() do
		local cloned = model:Clone()
		local house_owner_folder = ReplicatedStorage.runtimeasset.npc
		local client = world:get(id, c.Client)

		cloned.Name = owner_name
		cloned:AddTag(tags.HouseOwner)
		cloned.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
		cloned:SetAttribute(attributes.serverid, id)
		cloned.Parent = house_owner_folder

		--//TODO: tbh idk if we need to keep this? we will see tho
		world:set(id, p.ModelOf(c.HouseOwner), cloned)

		-- Once this is setup, now we want to setup the House for this owner
		-- We add the required components so that the system can work it out
		local house_to_setup: t.BuildingsType
		if client ~= nil then
			local store = playerdatastore[client]
			house_to_setup = store.housetype
			warn(`>>>>>> PLAYER HOUSE MODEL SETUP!! WHOOOHOO`)
		else
			--//TODO: there will be a better logic on deciding what NPC house to create
			house_to_setup = "House_BasicHouse"
		end

		warn(`Creating a house owner entity {id}`)

		world:set(claimed_plot_id, p.Create(c.House), house_to_setup)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.Housing.HousingOnPlayerAdded,
	runConditions = {},
}
