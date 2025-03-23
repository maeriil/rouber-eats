local effects = {
	expDecaySize = function(baseSize: number, index: number)
		return baseSize * math.exp(-index * 0.3) + baseSize * 0.3
	end,
	inverseZigzagSize = function(baseSize: number, index: number)
		local base = baseSize / math.sqrt(index)
		local spike = (index % 2 == 0) and 1.2 or 0.8 -- Alternate size bumps
		return base * spike
	end,
	extremeWaveSize = function(baseSize: number, index: number)
		return baseSize * (0.5 + 0.5 * math.abs(math.sin(index * 1.2)))
	end,
	chaoticBounceSize = function(baseSize: number, index: number)
		return baseSize * (1.2 - (math.sin(index * 2) * 0.4))
	end,
	exponentialDrop = function(baseSize: number, index: number)
		return baseSize * (1 / (index ^ 0.6)) -- 0.6 controls how fast it shrinks
	end,
	jaggedSize = function(baseSize: number, index: number)
		return baseSize * (1 - 0.5 * math.sin(index * 1.5)) -- Sine wave effect
	end,
	chaoticSize = function(baseSize: number, index: number)
		return baseSize * (1 / math.sqrt(index % 3 + 1)) -- Uses modulo for variation
	end,
	doubleWave = function(baseSize: number, index: number)
		return baseSize * (0.5 + 0.4 * math.sin(index) + 0.3 * math.cos(index * 1.5))
	end,

	mWave = function(baseSize: number, index: number)
		return baseSize * (1 - 0.3 * math.sin(index * 2) ^ 2) -- Makes it dip then rise
	end,
}

return effects
