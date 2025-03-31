local ContextActionService = game:GetService("ContextActionService")

local function freeze_player_movement()
	local FREEZE_ACTION = "freezeMovement"

	ContextActionService:BindAction(FREEZE_ACTION, function()
		return Enum.ContextActionResult.Sink
	end, false, unpack(Enum.PlayerActions:GetEnumItems()))
end

local function unfreeze_player_movement()
	local FREEZE_ACTION = "freezeMovement"

	ContextActionService:UnbindAction(FREEZE_ACTION)
end

return {
	freeze = freeze_player_movement,
	unfreeze = unfreeze_player_movement,
}
