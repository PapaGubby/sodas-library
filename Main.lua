return function()
	local base = "https://raw.githubusercontent.com/PapaGubby/sodas-library/main/"

	local DEBUG = true

	local function log(tag, msg)
		if DEBUG then
			print("[SODA][LOADER][" .. tag .. "] " .. msg)
		end
	end

	log("BOOT", "starting library bootstrap")

	local function get(path)
		log("HTTP", "requesting " .. path)

		local ok, res = pcall(function()
			return game:HttpGet(base .. path)
		end)

		if not ok then
			log("HTTP_FAIL", tostring(res))
			return nil
		end

		log("HTTP_OK", path)
		return res
	end

	local function safeLoad(path)
		local src = get(path)
		if not src then
			log("SKIP", path)
			return nil
		end

		if src:sub(1, 5) == "<html" then
			log("INVALID", "html returned for " .. path)
			return nil
		end

		log("LOADSTRING", "compiling " .. path)

		local fn, err = loadstring(src)
		if not fn then
			log("COMPILE_FAIL", path .. " " .. tostring(err))
			return nil
		end

		local ok, res = pcall(fn)
		if not ok then
			log("RUNTIME_FAIL", path .. " " .. tostring(res))
			return nil
		end

		log("OK", path)
		return res
	end

	log("CORE", "loading core modules")

	local Core = {}

	Core.Maid = safeLoad("Library/Core/Maid.lua")
	Core.Signal = safeLoad("Library/Core/Signal.lua")
	Core.Tween = safeLoad("Library/Core/Tween.lua")
	Core.Window = safeLoad("Library/Core/Window.lua")
	Core.UI = safeLoad("Library/Core/UI.lua")

	local ScriptsPath = base .. "Library/Scripts/"

	local function loadScript(name)
		log("SCRIPT", "loading " .. name)

		local ok, res = pcall(function()
			return game:HttpGet(ScriptsPath .. name .. ".lua")
		end)

		if not ok then
			log("SCRIPT_HTTP_FAIL", name .. " " .. tostring(res))
			return nil
		end

		local fn, err = loadstring(res)
		if not fn then
			log("SCRIPT_COMPILE_FAIL", name .. " " .. tostring(err))
			return nil
		end

		local ok2, module = pcall(fn)
		if not ok2 then
			log("SCRIPT_RUN_FAIL", name .. " " .. tostring(module))
			return nil
		end

		log("SCRIPT_OK", name)
		return module
	end

	log("UI", "creating window")

	local ui = Core.Window.new({
		Name = "Soda Library",
		Size = UDim2.new(0, 520, 0, 360)
	})

	local running = {}

	local function register(name)
		local script = loadScript(name)
		if not script then
			log("REGISTER_FAIL", name)
			return
		end

		local page = ui:AddPage(script.Name, script.Description)

		page:AddButton("Run", function()
			if running[name] then
				log("RUN_BLOCKED", name)
				return
			end

			log("RUN", name)

			local ok, res = pcall(function()
				return script.Run(Core)
			end)

			if not ok then
				log("RUN_ERROR", name .. " " .. tostring(res))
				return
			end

			running[name] = res
			log("RUN_OK", name)
		end)

		page:AddButton("Stop", function()
			log("STOP", name)

			if running[name] then
				if running[name].Destroy then
					local ok, err = pcall(function()
						running[name]:Destroy()
					end)

					if not ok then
						log("STOP_ERROR", tostring(err))
					end
				end

				running[name] = nil
				log("STOP_OK", name)
			end
		end)
	end

	log("SCRIPTS", "registering scripts")

	register("Example")
	register("ButtonTest")
	register("ToggleTest")

	log("READY", "library loaded")

	return Core
end
