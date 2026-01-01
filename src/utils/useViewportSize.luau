local Workspace = game:GetService("Workspace")
local function useViewportSize(): Vector2
	local camera = Workspace:FindFirstChildOfClass("Camera")
	if camera then
		return camera.ViewportSize
	end
	return Vector2.zero
end

return useViewportSize
