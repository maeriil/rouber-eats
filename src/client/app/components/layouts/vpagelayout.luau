-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide              = require(ReplicatedStorage.pkg.vide)

local create            = vide.create

type can<T> = T?

type props = {
  pad                : () -> UDim,
  circular           : can<boolean | () -> boolean>,
  halign             : can<Enum.HorizontalAlignment>,
  valign             : can<Enum.VerticalAlignment>,
  -- jump_to_idx     : (n: number) -> (),
  -- next            : () -> (),
  -- prev            : () -> (),
  animated_style     : can<Enum.EasingStyle>,
  animated_direction : can<Enum.EasingDirection>,
  animated_time      : can<number>,
  on_page_enter      : can<(page: Instance) -> ()>;
  on_page_leave      : can<(page: Instance) -> ()>;
  on_page_stopped    : can<(currpage: Instance) -> ()>;
  scroll_enabled     : can<boolean | () -> boolean>;
  [number]           : any,
}
-- stylua: ignore end

local function vpagelayout(props: props)
	local page = create "UIPageLayout" {
    -- stylua: ignore start
    FillDirection           = Enum.FillDirection.Vertical,
    SortOrder               = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment     = props.halign or Enum.HorizontalAlignment.Center,
    VerticalAlignment       = props.valign or Enum.VerticalAlignment.Top,
    Circular                = props.circular,
    EasingStyle             = props.animated_style,
    EasingDirection         = props.animated_direction,
    TweenTime               = props.animated_time,
    Padding                 = props.pad or UDim2.new(),
    PageEnter               = props.on_page_enter,
    PageLeave               = props.on_page_leave,
    Stopped                 = props.on_page_stopped,
    ScrollWheelInputEnabled = props.scroll_enabled or true,

		unpack(props),
		-- stylua: ignore end
	}

	return page
end

return vpagelayout
