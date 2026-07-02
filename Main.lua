return function()
	local base = "https://raw.githubusercontent.com/PapaGubby/sodas-library/main/"

	local function get(path)
		return game:HttpGet(base .. path)
	end

	local Core = {}

	Core.Maid = loadstring(get("Library/Core/Maid.lua"))()
	Core.Signal = loadstring(get("Library/Core/Signal.lua"))()
	Core.Tween = loadstring(get("Library/Core/Tween.lua"))()
	Core.Window = loadstring(get("Library/Core/Window.lua"))()
	Core.UI = loadstring(get("Library/Core/UI.lua"))()

	local ScriptsPath = base .. "Library/Scripts/"

	local function loadScript(name)
		return loadstring(game:HttpGet(ScriptsPath .. name .. ".lua"))()
	end

	local ui = Core.Window.new({
		Name = "Soda Library",
		Size = UDim2.new(0, 520, 0, 360)
	})

	local running = {}

	local function register(name)
		local script = loadScript(name)
		if not script then return end

		local page = ui:AddPage(script.Name, script.Description)

		page:AddButton("Run", function()
			if running[name] then return end
			running[name] = script.Run(Core)
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

	return Core
end
