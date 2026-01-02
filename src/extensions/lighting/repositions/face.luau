local reflect = require("../reflect")
local types = require("../types")

local FaceReposition = {} :: types.Reposition
FaceReposition.id = "face"
FaceReposition.title = "Face"
FaceReposition.describedBy = "a reflection on a face."

function FaceReposition.getDirection(_, now)
	local rayDirection = CFrame.lookAt(now.cameraPosition, now.mousePosition)
	local raycast = workspace:Raycast(now.cameraPosition, rayDirection.LookVector * 10000)

	if not raycast then
		return nil
	end

	local reflection = reflect(rayDirection.LookVector, raycast.Normal)
	return CFrame.lookAt(raycast.Position, raycast.Position + reflection).LookVector
end

return FaceReposition
