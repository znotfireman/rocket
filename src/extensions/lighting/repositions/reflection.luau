local reflect = require("../reflect")
local types = require("../types")

local ReflectionReposition = {} :: types.Reposition
ReflectionReposition.id = "reflection"
ReflectionReposition.title = "Reflection"
ReflectionReposition.describedBy = "reflection at your mouse."

function ReflectionReposition.getDirection(_, now)
	local reflection = reflect(now.mouseDirection, Vector3.new(0, 1, 0))
	return CFrame.lookAt(now.mousePosition, now.mousePosition + reflection).LookVector
end

return ReflectionReposition
