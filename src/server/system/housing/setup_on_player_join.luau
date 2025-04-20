-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs              = require(ReplicatedStorage.pkg.jecs)
local phases            = require(ReplicatedStorage.common.ecs.phases)

local p                 = require(ReplicatedStorage.common.ecs.pairs)
local c                 = require(ReplicatedStorage.common.ecs.components)
local world             = require(ReplicatedStorage.common.ecs.world)
local __                = jecs.Wildcard

local player_wihout_house_owner = world
	:query(c.Model)
	:with(c.Client)
	:without(c.HouseOwner)
  :cached()
-- stylua: ignore end

local function system()
	for client_id, model in player_wihout_house_owner:iter() do
		world:set(client_id, p.Create(c.Model), model)
		world:add(client_id, c.HouseOwner)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
