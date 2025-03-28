_G.__JECS_DEBUG = false

local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local debug_scheduler_order = require(script.Parent.debug_scheduler_order)
local jabby = require(ReplicatedStorage.pkg.jabby)
local jecs = require(ReplicatedStorage.pkg.jecs)
local rewire = require(ReplicatedStorage.pkg.rewire)
local scheduler = require(script.Parent.scheduler)
local world = require(script.Parent.world)

local function flatten_module(current: Instance, modules: { ModuleScript })
	if current:IsA("ModuleScript") then
		table.insert(modules, current)
	end

	for i, inst in current:GetChildren() do
		flatten_module(inst, modules)
	end

	return modules
end

local function start(folders: { Folder })
	local module_system_map: { [ModuleScript]: jecs.Entity<nil> } = {}
	local hotreload = rewire.HotReloader.new()

	for i, folder in folders do
		hotreload:scan(folder, function(module: ModuleScript, context)
			local orig_module = context.originalModule
			local ok, system = pcall(require, module)

			if not ok then
				warn("Error when hot-reloading system", module.Name, system)
				return
			end

			if orig_module and module_system_map[orig_module] then
				scheduler:replaceSystem(module_system_map[orig_module], system)
			else
				scheduler:addSystem(system)
			end
			module_system_map[orig_module] = system
		end, function(module: ModuleScript, context)
			if context.isReloading then
				return
			end

			local orig_module = context.originalModule
			if module_system_map[orig_module] then
				scheduler:removeSystem(module_system_map[orig_module])
				module_system_map[orig_module] = nil
			end
		end)
	end

	-- debug_scheduler_order(scheduler, true)

	if RunService:IsClient() then
		local client = jabby.obtain_client()

		local function create_widget(_, state: Enum.UserInputState)
			if state ~= Enum.UserInputState.Begin then
				return
			end
			client.spawn_app(client.apps.home, nil)
		end
		ContextActionService:BindAction("Open Jabby", create_widget, false, Enum.KeyCode.F4)
	end

	jabby.register {
		applet = jabby.applets.world,
		name = "world",
		configuration = {
			world = world,
		},
	}
end

return start
