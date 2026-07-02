local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_connections = {}
	}, Signal)
end

function Signal:Connect(fn)
	local conn = {fn = fn, alive = true}

	function conn:Disconnect()
		self.alive = false
	end

	table.insert(self._connections, conn)

	return conn
end

function Signal:Fire(...)
	for _, c in ipairs(self._connections) do
		if c.alive then
			task.spawn(c.fn, ...)
		end
	end
end

return Signal
