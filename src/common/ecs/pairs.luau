local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local pair = jecs.pair
local c = require(script.Parent.components)

return {
	IncreaseCoins = pair(c.Coins, c.Increase),
	IncreaseGems = pair(c.Gems, c.Increase),
	DecreaseCoins = pair(c.Coins, c.Decrease),
	DecreaseGems = pair(c.Gems, c.Decrease),

	DoNotUpdateModel = pair(c.DoNotReconcile, c.Model),

	TweenStart = pair(c.Tween, c.Start),
	TweenEnd = pair(c.Tween, c.End),

	TPCooldown = pair(c.Lifetime, c.TeleportTo),
}
