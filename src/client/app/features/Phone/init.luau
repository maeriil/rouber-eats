local ReplicatedStorage = game:GetService("ReplicatedStorage")
local border = require(ReplicatedStorage.client.app.components.border.border)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local hsquare = require(ReplicatedStorage.client.app.components.ratio.hsquare)
local lightgray = require(ReplicatedStorage.client.app.components.gradients.lightgray)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local phoneconfig = require(script.phoneconfig)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vibrantred = require(ReplicatedStorage.client.app.components.gradients.vibrantred)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local px = use_px.px

local create = vide.create

type can<T> = T | () -> T
type Source<T> = vide.Source<T>
type props = {}

local function icon(props: {
	img: can<string>,
	order: can<number>?,
})
	return create "ImageLabel" {
		LayoutOrder = props.order,
		Image = props.img,
		BackgroundTransparency = 1,
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		square {},
	}
end

local cellular_icon = "http://www.roblox.com/asset/?id=4458875410"
local wifi_icon = "http://www.roblox.com/asset/?id=119759670842477"
local battery_icon = "http://www.roblox.com/asset/?id=4876561955"

local function header(props: {
	height: number,
	order: can<number>?,
	[number]: any,
})
	local order = next_order()
	return frame {
		name = "header",
		order = props.order,
		size = function()
			return UDim2.new(1, 0, 0, px(48))
		end,
		lightgray {},
		pane {
			padding {
				y = function()
					return UDim.new(0, px(6))
				end,
			},
			hlayout {
				pad = function()
					return UDim.new(0, px(8))
				end,
			},
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			pane {
				order = order(),
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				flexfill {},
				padding {
					y = function()
						return UDim.new(0, px(8))
					end,
					x = function()
						return UDim.new(0, px(8))
					end,
				},
				hlayout {
					halign = Enum.HorizontalAlignment.Right,
					hflex = Enum.UIFlexAlignment.SpaceEvenly,
				},
				par {
					text = text_sizes.bolded("09:20"),
					xalign = Enum.TextXAlignment.Right,
				},
			},
			frame {
				order = order(),
				color = Color3.fromRGB(20, 20, 20),
				name = "notch",
				size = function()
					return UDim2.new(0, px(150), 1, 0)
				end,
				circle {},
			},
			pane {
				order = order(),
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				flexfill {},
				padding {
					y = function()
						return UDim.new(0, px(8))
					end,
					x = function()
						return UDim.new(0, px(8))
					end,
				},
				hlayout {
					pad = function()
						return UDim.new(0, 0)
					end,
					hflex = Enum.UIFlexAlignment.SpaceEvenly,
				},
				icon {
					img = cellular_icon,
					order = order(),
				},
				icon {
					img = wifi_icon,
					order = order(),
				},
				icon {
					img = battery_icon,
					order = order(),
				},
			},
		},
	}
end

local function avatar(props: {
	img: can<string>,
	name: can<string>,
	click: () -> (),
})
	return {
		vlayout {},
		create "ImageButton" {
			Size = UDim2.new(1, 0, 0.6, 0),
			Image = props.img,
			BackgroundTransparency = 0,
			Activated = function()
				props.click()
			end,
			square {},
			circle {},
		},
		pane {
			size = UDim2.new(1, 0, 0, px(22)),
			par {
				text = props.name,
				xalign = Enum.TextXAlignment.Center,
			},
		},
	}
end

--TODO: We should probably pass avatar as child of body header
local leftarrow_icon = "http://www.roblox.com/asset/?id=6993472329"
local video_icon = "http://www.roblox.com/asset/?id=15020809372"
local function bodyheader(props: {
	order: can<number>?,
	img: can<string>,
	name: can<string>,
})
	local order = next_order()
	return frame {
		size = function()
			return UDim2.new(1, 0, 0, px(92))
		end,
		order = props.order,
		lightgray {},
		hlayout {},
		pane {
			order = order(),
			vlayout {
				vflex = Enum.UIFlexAlignment.SpaceEvenly,
			},
			size = UDim2.new(0, px(50), 1, 0),
			padding {
				y = function()
					return UDim.new(0, px(16))
				end,
			},
			icon {
				img = leftarrow_icon,
			},
		},
		pane {
			order = order(),
			size = UDim2.new(1, 0, 1, 0),
			flexfill {},
			avatar {
				click = function() end,
				img = props.img,
				name = props.name,
			},
		},
		pane {
			order = order(),
			vlayout {
				vflex = Enum.UIFlexAlignment.SpaceEvenly,
			},
			size = UDim2.new(0, px(50), 1, 0),
			padding {
				y = function()
					return UDim.new(0, px(16))
				end,
			},
			icon {
				img = video_icon,
			},
		},
	}
end

local function content(props: {
	order: can<number>?,
	[number]: any,
})
	return frame {
		order = props.order,
		size = UDim2.new(1, 0, 1, 0),
		flexfill {},
		unpack(props),
	}
end

local sample_pfp = "http://www.roblox.com/asset/?id=11849348275"
local sample_name = "maeriil"

--//TODO This can be a generic component, export it out
local function exitbutton(props: {
	click: () -> (),
})
	local img = "http://www.roblox.com/asset/?id=14945994307"
	local red = Color3.fromRGB(255, 0, 0)
	return pane {
		size = UDim2.new(0, px(48), 0, px(36)),
		padding {
			padding = function()
				return UDim.new(0, px(4))
			end,
		},
		create "ImageButton" {
			Size = UDim2.new(1, 0, 1, 0),
			Image = img,
			ImageColor3 = red,
			BackgroundTransparency = 1,
			circle {},
		},
		circle {},
		border {
			vibrantred {},
		},
	}
end

type Base = {
	Duration: number,
	Data: {},
}

local function phone(props: props)
	local order = next_order()
	return pane {
		size = UDim2.new(1, 0, 1, 0),
		pane {
			order = order(),
			size = UDim2.new(1, 0, 1, 0),
			flexfill {},
			pane {
				padding {
					x = function()
						return UDim.new(0, px(16))
					end,
				},
				hlayout {},
				name = "header",
				size = function()
					return UDim2.new(1, 0, 0, px(48))
				end,
				exitbutton {
					click = function() end,
				},
			},
		},
		hlayout {},
		frame {
			vlayout {
				pad = function()
					return UDim.new(0, px(8))
				end,
			},
			color = Color3.fromRGB(0, 255, 0),
			order = order(),
			size = UDim2.new(0, px(64), 1, 0),
			pane {
				name = "padding",
				size = function()
					return UDim2.new(1, 0, 0, px(92 + 48 - 8))
				end,
				order = order(),
			},
			--[[
                Home
                Chat
                Stats
                Shop = we want to use landscape layout for this
            ]]
			frame {
				order = order(),
				color = Color3.fromRGB(255, 0, 0),
				size = UDim2.new(1, 0, 1, 0),
				hsquare {},
			},
		},
		pane {
			order = order(),
			size = function()
				return UDim2.new(phoneconfig.phonewidth, 0, 1, 0)
			end,
			pos = UDim2.new(1, 0, 0, 0),
			anchor = Vector2.new(1, 0),
			vlayout {},
			header {
				height = phoneconfig.headerheight,
				order = order(),
			},
			bodyheader {
				order = order(),
				img = sample_pfp,
				name = sample_name,
			},
			content {
				order = order(),
			},
		},
	}
end

return phone
