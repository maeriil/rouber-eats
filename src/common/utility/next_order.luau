--[=[
    Increments and returns the next order counter
    Useful for Layout Orderings

    @return function (void) -> number
]=]
return function(): () -> number
	local order = 0

	return function()
		order += 1
		return order
	end
end
