local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local backpack_viewport_card =
	require(ReplicatedStorage.client.app.pages.BackpackScreen.backpack_viewport_card)
local uistore = require(ReplicatedStorage.client.app.uistore)
local vide = require(ReplicatedStorage.pkg.vide)
local types = require(ReplicatedStorage.types)
type props = {}

local values = vide.values

local function backpack_furnishings(props: props)
	local my_furnishings = uistore.backpack_furnishings

	return {

		values(my_furnishings, function(content, order: () -> number)
			return pane {
				-- backpack_viewport_card {},
			}
		end),
	}
end

return backpack_furnishings
