local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
type can<T> = T | () -> T

type props = {
	pad: can<UDim>?,
	valign: can<Enum.VerticalAlignment>?,
	halign: can<Enum.HorizontalAlignment?>,
	wraps: can<boolean>?,
	vflex: can<Enum.UIFlexAlignment>?,
	hflex: can<Enum.UIFlexAlignment>?,
}

local function vlayout(props: props)
	return create "UIListLayout" {
		Padding = props.pad,
		VerticalAlignment = props.valign or function()
			return Enum.VerticalAlignment.Top
		end,
		HorizontalAlignment = props.halign or function()
			return Enum.HorizontalAlignment.Center
		end,
		Wraps = props.wraps,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalFlex = props.hflex,
		VerticalFlex = props.vflex,
	}
end

return vlayout
