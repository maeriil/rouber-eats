local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)
local world = require(script.Parent.world)

local refs: { [any]: t.Entity } = {}

local function fini(key): () -> ()
	return function()
		refs[key] = nil
	end
end

local function noop() end

local function ref(key): (jecs.Entity<any>, () -> ())
	if not key then
		return world:entity(), noop
	end
	local e = refs[key]
	if not e then
		e = world:entity()
		refs[key] = e
	end
	-- Cannot cache handles because they will get invalidated
	return e, fini(key)
end

return ref
