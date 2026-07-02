local TweenService = game:GetService("TweenService")

local Tween = {}

function Tween.Play(instance, info, props)
	local tween = TweenService:Create(instance, info, props)
	tween:Play()
	return tween
end

return Tween
