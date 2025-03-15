local function get_true_ancestor(model: Model)
	local parent = model:FindFirstAncestorOfClass("Model")

	if parent == nil then
		return model
	end

	return get_true_ancestor(parent)
end

return get_true_ancestor
