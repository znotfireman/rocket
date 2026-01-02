local types = require("../types")

local LineReposition = {} :: types.Reposition
LineReposition.id = "line"
LineReposition.title = "Line"

function LineReposition.getDirection(initial, now)
	return CFrame.lookAt(now.mousePosition, initial.mousePosition).LookVector
end

return LineReposition
