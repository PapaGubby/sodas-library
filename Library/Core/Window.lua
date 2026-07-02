local Maid = require(script.Parent.Maid)

local Window = {}
Window.__index = Window

function Window.new(cfg)
	local self = setmetatable({}, Window)
	self.Maid = Maid.new()

	local gui = Instance.new("ScreenGui")
	gui.Name = cfg.Name
	gui.ResetOnSpawn = false
	gui.Parent = game:GetService("CoreGui")

	local main = Instance.new("Frame")
	main.Size = cfg.Size
	main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	main.Parent = gui

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 130, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(30,30,30)
	sidebar.Parent = main

	local pages = Instance.new("Frame")
	pages.Size = UDim2.new(1, -130, 1, 0)
	pages.Position = UDim2.new(0, 130, 0, 0)
	pages.Parent = main

	self.Gui = gui
	self.Main = main
	self.Sidebar = sidebar
	self.Pages = pages
	self.PageList = {}

	return self
end

function Window:AddPage(name, desc)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 28)
	button.Text = name
	button.Parent = self.Sidebar

	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.Visible = false
	page.Parent = self.Pages

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 40)
	label.Text = desc
	label.Parent = page

	button.MouseButton1Click:Connect(function()
		for _, p in pairs(self.Pages:GetChildren()) do
			p.Visible = false
		end
		page.Visible = true
	end)

	local api = {}

	function api:AddButton(text, callback)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 200, 0, 30)
		b.Text = text
		b.Parent = page
		b.MouseButton1Click:Connect(callback)
	end

	return api
end

return Window
