-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local basebutton        = require(ReplicatedStorage.client.app.components.button.basebutton)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local vlayout           = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding           = require(ReplicatedStorage.client.app.components.padding)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local effect2           = require(ReplicatedStorage.client.app.features.ActiveEffect.effect2)
local vide              = require(ReplicatedStorage.pkg.vide)

local source            = vide.source
local create            = vide.create
local spring            = vide.spring

type props = {
  yes : () -> (),
  no  : () -> (),
}
-- stylua: ignore end

local function pose_confirm_choice(props: props)
	local img = assets.images["ActionBubble.svg"]
	local selecting_yes = source(true)
	local pos = spring(function()
		return selecting_yes() and UDim2.new(0, 0, 0.8, 0) or UDim2.new(0, 0, 1, 0)
	end, 0.2)

	return {
		pane {
			pane {
				rotation = 180,
				baseimage {
					img = img,
					color = function()
						return Color3.fromRGB(255, 255, 255)
					end,
				},
			},

			pane {
				name = "content",
				size = function()
					return UDim2.new(0.75, 0, 0.85, 0)
				end,
				pos = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				anchor = Vector2.new(0.5, 0.5),
				vlayout {},
				padding {
					y = padding_types.px16,
				},
				create "Folder" {
					pane {
						size = function()
							return UDim2.new(1, 0, 0.2, 0)
						end,
						anchor = Vector2.new(0, 1),
						pos = pos,
						effect2 {},
					},
				},
				pane {
					color = Color3.fromRGB(0, 255, 0),
					order = 1,
					size = function()
						return UDim2.new(1, 0, 0.6, 0)
					end,
					rtext {
						text = function()
							return `Pick some display pose name?`
						end,
						italic = true,
						wrap = true,
						yalign = Enum.TextYAlignment.Bottom,
					},
				},
				pane {
					color = Color3.fromRGB(255, 255, 0),
					order = 2,
					size = function()
						return UDim2.new(1, 0, 0.2, 0)
					end,
					rtext {
						text = function()
							return `Yes!`
						end,
						bolded = true,
					},
					basebutton {
						click = props.yes,
						hoverenter = function()
							selecting_yes(true)
						end,
					},
				},
				pane {
					color = Color3.fromRGB(0, 255, 255),
					order = 3,
					size = function()
						return UDim2.new(1, 0, 0.2, 0)
					end,
					rtext {
						text = function()
							return `No`
						end,
						bolded = true,
					},
					basebutton {
						click = props.no,
						hoverenter = function()
							selecting_yes(false)
						end,
					},
				},
			},
		},
	}
end

return pose_confirm_choice
