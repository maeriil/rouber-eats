local function animation_list(list: { string }, animator: Animator): { AnimationTrack }
	local tracks = {} :: { AnimationTrack }

	for i, animationid in list do
		local track = Instance.new("Animation")
		track.AnimationId = animationid

		local loaded_track = animator:LoadAnimation(track)
		table.insert(tracks, loaded_track)
	end

	return tracks
end

return animation_list
