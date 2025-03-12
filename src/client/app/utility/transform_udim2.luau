local function transform_udim2(
	original: UDim2,
	factor: number | { x: number, y: number },
	ignore_scale: boolean?
)
	ignore_scale = ignore_scale or false

	local x_scale_factor = 1
	local y_scale_factor = 1

	if type(factor) == "table" then
		x_scale_factor = factor.x or 1
		y_scale_factor = factor.y or 1
	else
		x_scale_factor = factor
		y_scale_factor = factor
	end

	local x = original.X
	local y = original.Y

	local new_scale_x = if ignore_scale then x.Scale else x.Scale * x_scale_factor
	local new_scale_y = if ignore_scale then y.Scale else y.Scale * y_scale_factor
	local new_offset_x = x.Offset * x_scale_factor
	local new_offset_y = y.Offset * y_scale_factor

	return UDim2.new(new_scale_x, new_offset_x, new_scale_y, new_offset_y)
end

return transform_udim2
