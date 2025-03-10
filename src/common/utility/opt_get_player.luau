local Players = game:GetService("Players")
local function opt_get_player(part: BasePart): Player | nil
	local char = part:FindFirstAncestorOfClass("Model")
	if not char then
		return nil
	end
	return Players:GetPlayerFromCharacter(char)
end

return opt_get_player
