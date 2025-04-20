local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local pair = jecs.pair
local c = require(script.Parent.components)

return {
	DoNotUpdateModel = pair(c.DoNotReconcile, c.Model),

	TPCooldown = pair(c.Lifetime, c.TeleportTo),
	InteractedCooldown = pair(c.Lifetime, c.Interacted),

	-- OwnedBy = pair(c.EntityId, c.OwnedBy),
	OwnerOf = pair(c.EntityId, c.OwnerOf),

	childof = function<T>(entity: t.Entity)
		return jecs.pair(jecs.ChildOf, entity)
	end,

	previous = function<T>(component: jecs.Id<T>)
		return jecs.pair(component, jecs.Rest) :: jecs.Pair<T, nil>
	end,

	Increase = function<T>(component: t.Entity | t.Id)
		return jecs.pair(component, c.Increase) :: jecs.Pair<T, nil>
	end,
	Decrease = function<T>(component: t.Entity | t.Id)
		return jecs.pair(component, c.Decrease) :: jecs.Pair<T, nil>
	end,
	Start = function<T>(component: t.Entity | t.Id)
		return jecs.pair(component, c.Start) :: jecs.Pair<T, nil>
	end,
	End = function<T>(component: t.Entity | t.Id)
		return jecs.pair(component, c.End) :: jecs.Pair<T, nil>
	end,
	EntityId = function(component: t.Entity | t.Id)
		return jecs.pair(c.EntityId, component)
	end,
	Transform = function(component: t.Entity | t.Id)
		return jecs.pair(c.Transform, component)
	end,
	Lifetime = function(component: t.Entity | t.Id)
		return jecs.pair(c.Lifetime, component)
	end,
	Create = function<T>(component: t.Entity<T>)
		return jecs.pair(component, c.Create) :: jecs.Pair<T, nil>
	end,
	ModelOf = function(component: t.Entity)
		return jecs.pair(c.Model, component)
	end,
	ConfigOf = function<T>(component: t.Entity<T>)
		return jecs.pair(component, c.Config) :: jecs.Pair<T, nil>
	end,
}
