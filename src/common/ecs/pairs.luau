local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local pair = jecs.pair
local c = require(script.Parent.components)

return {
	IncreaseCoins = pair(c.Coins, c.Increase),
	IncreaseGems = pair(c.Gems, c.Increase),
	DecreaseCoins = pair(c.Coins, c.Decrease),
	DecreaseGems = pair(c.Gems, c.Decrease),
	IncreaseRating = pair(c.Rating, c.Increase),
	DecreaseRating = pair(c.Rating, c.Decrease),

	DoNotUpdateModel = pair(c.DoNotReconcile, c.Model),

	TweenStart = pair(c.Tween, c.Start),
	TweenEnd = pair(c.Tween, c.End),

	TPCooldown = pair(c.Lifetime, c.TeleportTo),
	InteractedCooldown = pair(c.Lifetime, c.Interacted),

	StartTransform = pair(c.Transform, c.Position),
	EndTransform = pair(c.Transform, c.End),

	OwnedBy = pair(c.EntityId, c.OwnedBy),
	OwnerOf = pair(c.EntityId, c.OwnerOf),
	ClaimedBy = pair(c.EntityId, c.Claim),

	BuildingInteriorId = pair(c.EntityId, c.Interior),
	BuildingExteriorId = pair(c.EntityId, c.Exterior),

	DoormatTransform = pair(c.Transform, c.DoormatZone),
	PlayerExteriorTPTransform = pair(c.Transform, c.TeleportZone),

	childof = function<T>(entity: t.Entity)
		return jecs.pair(jecs.ChildOf, entity)
	end,

	-- cooldown = function<T>(component: t.Entity<T>)
	-- 	return jecs.pair(c.Cooldown, component)
	-- end,

	previous = function<T>(component: jecs.Id<T>)
		return jecs.pair(component, jecs.Rest)
	end,
}
