local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.pkg.vide)
--[[
  This file should contain all the sources related to the result screen.

]]

local source = vide.source

type current_animation_phase = "none" | "title" | "pose_1" | "checklist"

return {
	start_result_animation = source(false),
	start_animation_title = source(false),
	start_pose1 = source(false),
	color_correction_effect = source(false),
	current_animation_phase = source(""),
}
