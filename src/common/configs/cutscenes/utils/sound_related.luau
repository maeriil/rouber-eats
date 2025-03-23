local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local future = require(ReplicatedStorage.pkg.future)
local sounds = require(ReplicatedStorage.client.store.sounds)
local world = require(ReplicatedStorage.common.ecs.world)

local function play_sound(
	soundid: string,
	localplr: boolean?,
	duration: number?,
	delay_time: number?
)
	delay_time = delay_time or 0

	local id = world:entity()
	local sound = future.Future.new(function()
		local instance = if localplr then world:get(c.Client, c.Sound) else sounds.global
		assert(instance, "Sound instance must exist")

		instance.SoundId = soundid
		task.wait(delay_time)

		if duration ~= nil then
			instance.Looped = true
		end

		instance:Play()
		task.wait(duration or 0)

		return true
	end)

	world:add(id, c.CutsceneAction)
	world:set(id, c.SoundFuture, sound)

	return id
end

return {
	play_sound = play_sound,
}
