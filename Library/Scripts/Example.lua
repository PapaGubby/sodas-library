return {
	Name = "Example",
	Description = "prints every frame",

	Run = function(Core)
		local RunService = game:GetService("RunService")

		local conn
		conn = RunService.RenderStepped:Connect(function()
			print("Example running")
		end)

		return {
			Destroy = function()
				conn:Disconnect()
			end
		}
	end
}
