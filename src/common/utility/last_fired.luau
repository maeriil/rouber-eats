local function last_fired(t: number)
	local fired = {}

	local function valid(player: Player)
		local last_time = fired[player]
		local curr_time = os.clock()

		if last_time == nil then
			return true
		end
		return curr_time - last_time >= t
	end

	local function update(player: Player)
		fired[player] = os.clock()
	end

	return valid, update
end

return last_fired
