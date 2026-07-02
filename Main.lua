return function()
	local Library = {}

	local function get(url)
		return game:HttpGet(url)
	end

	local Core = loadstring(get("https://raw.githubusercontent.com/PapaGubby/sodas-library/main/Library/Core/UI.lua"))()
	local ScriptsFolder = "https://raw.githubusercontent.com/PapaGubby/sodas-library/main/Library/Scripts/"

	Library.Core = Core
	Library.Scripts = {}

	local function loadScript(name)
		local source = get(ScriptsFolder .. name .. ".lua")
		local func = loadstring(source)
		return func and func()
	end

	local ui = Core:CreateWindow({
		Name = "Soda Library",
		Size = UDim2.new(0, 500, 0, 350)
	})

	local running = {}

	local function register(name)
		local scriptModule = loadScript(name)
		if not scriptModule then return end

		local page = ui:AddPage(name, scriptModule.Description or "")

		page:AddButton("Run", function()
			if running[name] then return end
			running[name] = scriptModule.Run(Core)
		end)

		page:AddButton("Stop", function()
			if running[name] then
				if running[name].Destroy then
					running[name]:Destroy()
				end
				running[name] = nil
			end
		end)
	end

	register("Example")
	register("ButtonTest")
	register("ToggleTest")

	return Library
end
