export type frameprops_t = {
	order: number?,
	name: string?,
	pos: UDim2?,
	size: UDim2?,
	anchor: Vector2?,
	rotation: number?,
}

local function frame(props: frameprops_t)
	local frame = Instance.new("Frame")
	frame.Name = props.name or "invisible-frame"
	frame.Size = props.size or UDim2.new(1, 0, 1, 0)
	frame.Position = props.pos or UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = props.anchor or Vector2.new(0.5, 0.5)
	frame.Rotation = props.rotation or 0
	frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

	return frame
end

local function invisible_frame()
	local _frame = frame {}
	_frame.BackgroundTransparency = 1
	_frame.BorderSizePixel = 0

	return _frame
end

return {
	frame = frame,
	invisible_frame = invisible_frame,
}
