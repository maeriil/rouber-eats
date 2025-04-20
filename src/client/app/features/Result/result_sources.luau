local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)
--[[
  This file should contain all the sources related to the result screen.

]]

local source = vide.source
local _mock_conditions = {
	{ text = "Clear the stage", success = true },
	{ text = "Clear within 2 minutes", success = true },
	{ text = "Collected all the coins", success = false },
}

return {
	animate_lines = source(false),
	conditions = source(_mock_conditions :: types.Array<{
		success: boolean,
		text: string,
	}>),
	money = source(2399),
	currexp = source(850),
	maxexp = source(1000),
	currlevel = source(9),
}
