local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local in_cooldown = require(script.Parent.in_cooldown)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local in_interaction_cooldown = in_cooldown.in_interaction_cooldown

local function handle_proximity_interaction(
	interacted_request_with: types.ActiveProximity
)
	if interacted_request_with == nil then return end

	if in_interaction_cooldown(c.Client) then
		-- client can also have internal cooldown so
		-- Should we display on UI?? Probably not right?
		return
	end

	if not world:contains(interacted_request_with) then
		warn(
			`The requested entity {interacted_request_with} does not exist in the world. This is a serious bug, ingestigate`
		)
		return
	end

	if in_interaction_cooldown(interacted_request_with) then
		-- For ex, if we opened door interaction, we want to process once only, and if for ex
		-- player helpd it for too long or something, we shold ignore other requests right
		return
	end

	world:add(interacted_request_with, c.Interacted)
end

return handle_proximity_interaction
