local Teams = game:GetService("Teams")

local function create_team(color: BrickColor, name: string)
	local team = Instance.new("Team")
	team.TeamColor = color
	team.AutoAssignable = false
	team.Name = name
	team.Parent = Teams

	return team
end

return create_team
