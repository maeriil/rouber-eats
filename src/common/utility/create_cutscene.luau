local function is_action(v: any)
	return type(v) == "table" and v._action
end

type Action = {}
type TABLE = { [any]: any }

type cutscene_props = {

	[number]: { Action },
}

local function CUTSCENE(props: cutscene_props)
	local array = {}

	for i, v in ipairs(props) do
	end
end

local function ACTION(props: TABLE)
	return {
		_action = true,
		props = props,
	}
end

return {
	CUTSCENE = CUTSCENE,
	ACTION = ACTION,
}

--[[
  ACTION {
    name = "describe what the action is doing"
    who = localplayer
    what = components.Position
    goal = doormat.Position

  }

]]
