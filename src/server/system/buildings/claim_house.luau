local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair
local __ = jecs.Wildcard

--[[
    two things
    1) query for players that do not have residence
        if they own some residence, add components to claim the particular house
        fire all client

    2) query for claim this house event from client
        verify details
        if okay then , add components to claim the particular house
        fire all client

    3) iterate over claim the particular house
        mark it as claimed and remove claim stuff

]]

local function can_own_residence(player: Player)
	local e = ref(player)
	-- Check to see if they have enough money

	return true
end

local function setup_to_own_residence(player: Player, residence: Entity)
	local nevent = world:entity()
	world:set(nevent, pair(c.Residence, c.Claim), residence)
	world:set(nevent, c.Client, player)

	return nevent
end

local function event_handler()
	for _, player, model: Instance in events.IWantToClaimResidence:query() do
		if model == nil or not model:IsA("Model") then
			continue
		end
		local e = ref(model)
		local playere = ref(player)
		if not world:contains(e) then
			continue
		end

		if not world:has(e, c.Residence) then
			warn(`The passed model is not a valid residence. Needs error handling`)
			continue
		end

		local already_owned = world:target(e, c.OwnedBy) ~= nil
		if already_owned then
			warn(`The passed model is already owned by some other player. Needs error handling`)
			continue
		end

		warn(`TODO: update requirements to claiming the residence`)
		if not can_own_residence(player) then
			warn(`Player did not meet enough requirements to claim residence. Needs error handling`)
			continue
		end

		setup_to_own_residence(player, e)
	end
end

local without_res = world:query(c.Client):without(pair(c.Residence, c.OwnerOf)):cached()
local available_apt =
	world:query(c.Model):with(c.ApartmentUnit):without(pair(c.OwnedBy, __)):cached()
local function client_without_any_residence()
	for e, client in without_res:iter() do
		-- We only support apartments currently

		for apt_id, model in available_apt:iter() do
			setup_to_own_residence(client, apt_id :: Entity)
			break
		end
	end
end

local function claim_house()
	for id, player, res_id in world:query(c.Client, pair(c.Residence, c.Claim)):iter() do
		-- Assign the residence as Owendby player
		local player_id = ref(player)
		local store = playerstore[player]
		store.residence = res_id

		world:set(res_id, pair(c.OwnedBy, player_id))

		-- Here we deduct the coins
		-- anything else that needs to happen to denote that this player owns the house

		local res_model = world:get(res_id, c.Model)
		assert(res_model ~= nil, "Residence model must exist before client tries to make any requests")

		events.UpdateGlobalResidenceOwnership:send(res_model, player)
	end
end

local function system()
	-- client_without_any_residence()
	-- event_handler()
	-- claim_house()
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
