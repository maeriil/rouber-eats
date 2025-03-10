local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
export type JobType = {
	name: string,
	team: Team,
	color: BrickColor,
	max_players: number,
	component: jecs.Entity<nil>,
	count_query: jecs.Query<>,
}

return 0
