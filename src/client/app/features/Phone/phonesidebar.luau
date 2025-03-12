local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local panel = require(ReplicatedStorage.client.app.components.panel.panel)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type Props = {
	order: types.Can<number>,
	y: types.Can<number>,
}

local create = vide.create
local px = use_px.px
local read = vide.read

local function phonesidebar(props: Props) end

return phonesidebar
