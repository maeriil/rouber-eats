local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueScreenPanel =
	require(ReplicatedStorage.client.app.features.Dialogues.DialogueScreenPanel)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local uistore = require(ReplicatedStorage.client.app.uistore)
local vide = require(ReplicatedStorage.pkg.vide)

local source = vide.source
local derive = vide.derive
local effect = vide.effect

type props = {}

local function DialogueScene(props: props)
	return DialogueScreenPanel {}
end

return DialogueScene
