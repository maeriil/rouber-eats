export type DialogueConfig = {
	dialogue_id: string,
	conversation_distance: number,
	trigger_distance: number,
	initial_text: string,
}

local typecheck = {
	dialogue_id = "string",
	conversation_distance = "number",
	trigger_distance = "number",
	initial_text = "string",
}

local function get_dialogue_configs(configuration: Configuration)
	--[[
    The point of below is to ensure that i don't add any random attribute to the instance
    because sometimes, i might add something but forget to update on the script. So this should
    yell at me when it does that.
  ]]
	local attributes = configuration:GetAttributes()
	local config = {} :: DialogueConfig
	local found = table.clone(typecheck)
	local parent = configuration:FindFirstAncestorOfClass("Model") :: Model
	local parent_name = parent.Name

	for name, value in attributes do
		local check_value = typecheck[name]
		if check_value == nil then
			error(
				`Provided an invalid dialogue configuration of name {name}. Is this a mistake. Check {parent_name}?`
			)
		end

		local curr_datatype = typeof(value)
		assert(
			curr_datatype == check_value,
			`DialogueConfig expected {check_value} for the property {name}, but got {curr_datatype}. Check {parent_name}`
		)

		config[name] = value
		found[name] = true
	end

	print(found)
	for name, value in found do
		if value ~= true then
			error(`DialogueConfig expects {name} but no value is provided. Check {parent_name}`)
		end
	end

	return config
end

return get_dialogue_configs
