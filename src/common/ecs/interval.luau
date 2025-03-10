local function interval(t: number)
	local past = 0

	return function()
		local now = os.clock()
		local should_update = now - past >= t
		local status = false

		if should_update then
			status = true
			past = now
		else
			status = false
		end

		return status
	end
end

return interval
