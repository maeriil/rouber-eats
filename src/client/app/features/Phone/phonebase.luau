local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local panel = require(ReplicatedStorage.client.app.components.panel.panel)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local px = use_px.px
local read = vide.read

type props = {
	x: types.Can<number>,
	order: types.Can<number>,
}

local function phonebase(props: props) end

return phonebase
