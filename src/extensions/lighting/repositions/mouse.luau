local types = require("../types")

local MouseReposition = {} :: types.Reposition
MouseReposition.id = "mouse"
MouseReposition.title = "Mouse"
MouseReposition.describedBy = "your mouse's position."

function MouseReposition.getDirection(_, now)
	return now.mousePosition
end

return MouseReposition
