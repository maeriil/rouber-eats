local ReplicatedStorage = game:GetService("ReplicatedStorage")
local entry_card_props = require(ReplicatedStorage.client.app.features.RuberApp.entry_card_props)
local vide = require(ReplicatedStorage.pkg.vide)

local read = vide.read

type can<T> = T | () -> T

type EntryCardProps = entry_card_props.EntryCardDetails
type props = {
	details: can<EntryCardProps>,
}

local function entry_card_minimal(props: props) end

return entry_card_minimal
