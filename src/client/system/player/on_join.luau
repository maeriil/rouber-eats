local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local player = Players.LocalPlayer
local character_added = {} :: { Model }
local character_removed = {} :: { Model }

if player.Character then
	table.insert(character_added, player.Character)
end

player.CharacterAdded:Connect(function(character: Model)
	table.insert(character_added, character)
end)
player.CharacterRemoving:Connect(function(character: Model)
	table.insert(character_removed, character)
end)

local function system()
	for i = #character_added, 1, -1 do
		local character = character_added[i]

		local hrp = character.PrimaryPart
		assert(hrp, `Humanoid root part must be the primary parpt of the character?`)

		local rayparams = RaycastParams.new()
		rayparams:AddToFilter({ character } :: never)
		local overparams = OverlapParams.new()
		overparams:AddToFilter({ character } :: never)
		local overparam_radius = 5

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		assert(humanoid ~= nil, `Humanoid must exist in the character model at this point`)

		-- Since we clear c.Client on cleanup, we must ensure we add it back?
		world:add(c.Client, c.Client)
		world:set(c.Client, c.Model, character)
		world:set(c.Client, c.PrimaryPart, hrp)
		world:set(c.Client, c.RayParams, rayparams)
		world:set(c.Client, c.OverParams, overparams)
		world:set(c.Client, c.Radius, overparam_radius)
		world:set(c.Client, c.Humanoid, humanoid)

		-- warn(`Finished setting up the c.Client entity in client...`)

		character_added[i] = nil
	end

	for i = #character_removed, 1, -1 do
		local character = character_removed[i]
		character:Destroy()
		--[[
      TODO:
      do something like cleanup when player reset their character
    ]]

		-- Can we safely clear the client?
		warn(`clearing the client as character removed is called...`)
		world:clear(c.Client)

		character_removed[i] = nil
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.First,
	runConditions = {},
}
