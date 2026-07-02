local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({tasks = {}}, Maid)
end

function Maid:Give(task)
	table.insert(self.tasks, task)
	return task
end

function Maid:Cleanup()
	for _, t in ipairs(self.tasks) do
		pcall(function()
			if typeof(t) == "RBXScriptConnection" then
				t:Disconnect()
			elseif typeof(t) == "Instance" then
				t:Destroy()
			elseif type(t) == "function" then
				t()
			end
		end)
	end
	self.tasks = {}
end

return Maid
