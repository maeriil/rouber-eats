local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basepartmap = require(ReplicatedStorage.client.store.basepartmap)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local gizmo = require(ReplicatedStorage.common.utility.gizmo)
local phases = require(ReplicatedStorage.common.ecs.phases)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	local params, hrp, radius = world:get(c.Client, c.OverParams, c.PrimaryPart, c.Radius)
	if not world:has(c.Client, c.Model) or params == nil or hrp == nil or radius == nil then
		return
	end
	if world:has(c.Client, c.IsCutscenePlaying) then
		return
	end

	-- We want to make the propximity a little bit large
	radius *= 5

	local current_pos = hrp.Position
	local result = workspace:GetPartBoundsInRadius(current_pos, radius, params)
	local set = {}

	-- gizmo.sphere.drawWithStyle({
	-- 	alwaysOnTop = true,
	-- 	color = Color3.fromRGB(255, 0, 0),
	-- 	transparency = 0.5,
	-- }, current_pos, radius)

	-- Go through each proximity, and for each valid one, compute the distance and
	-- store it in a seperate table, sort the table, and the one thats closest to us
	-- we will verify if its less than ProximityThreshold, and if so, update the ActiveProximitysource
	-- Then we just update out proximity index list

	-- Doormat zone proximity tests, we might want to improve upon for other kinds

	local door_proximity = {} :: { types.DoorProximityDetails }
	local part_with_lowest_dist = nil
	local curr_lowest_dist = math.huge

	for _, part in result do
		if set[part] then
			continue
		end
		local id = basepartmap[part]

		if id == nil or not world:contains(id) then
			continue
		end
		if world:has(id, c.DoormatZone) then
			-- Its a doormat so now we store on set and sort by shortest ones
			local distance = (current_pos - part.Position).Magnitude

			if distance < curr_lowest_dist then
				curr_lowest_dist = distance
				part_with_lowest_dist = part
			end

			table.insert(set, part)
		end
	end

	-- Now if the lowest dist is less than like 10, then we can display prompt cuz player is
	-- most likely close enough

	if part_with_lowest_dist then
		for _, part in set do
			local id = basepartmap[part]
			local parent = world:parent(id)
			assert(parent ~= nil, "Every doormatzone must have a parent")

			local name = world:get(parent, c.Name) :: string
			assert(name, `Name is required for every building so we can use it for proximity text`)

			local is_exterior = world:has(parent, c.Exterior)
			local details: types.DoorProximityDetails = {
				adornee = part,
				exterior = is_exterior,
				promptid = id,
				proximity_text = name,
			}
			table.insert(door_proximity, details)
		end

		if curr_lowest_dist <= 10 then
			uistore.ActiveProximity(basepartmap[part_with_lowest_dist])
		else
			uistore.ActiveProximity(nil)
		end

		uistore.DoorProximity(door_proximity)
	else
		-- We aren't near any proximity, so render both of them as nil
		uistore.ActiveProximity(nil)
		uistore.DoorProximity({})
	end

	set = {}
end

return {
	name = script.Name,
	system = system,
	phase = phases.PreUpdate,
	runConditions = {},
}
