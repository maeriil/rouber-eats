local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local vide = require(ReplicatedStorage.pkg.vide)

vide.strict = RunService:IsStudio()

return vide
