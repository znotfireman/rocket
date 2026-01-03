local DirectionGizmo = require("./gizmos/DirectionGizmo")
local Iris = require("@src/Iris")
local reflect = require("../reflect")
local types = require("../types")

local FaceReposition = {} :: types.Reposition
FaceReposition.id = "face"
FaceReposition.title = "Face"
FaceReposition.describedBy = "a reflection on a face"

function FaceReposition.update(_, now, isGizmos)
	local rayDirection = CFrame.lookAt(now.cameraPosition, now.mousePosition)
	local raycast = workspace:Raycast(now.cameraPosition, rayDirection.LookVector * 10000)

	if not raycast then
		Iris.Tooltip("Cursor must be on a face!")
		return nil
	end

	local reflection = reflect(rayDirection.LookVector, raycast.Normal)
	local direction = CFrame.lookAt(raycast.Position, raycast.Position + reflection).LookVector

	if isGizmos then
		DirectionGizmo(now.mousePosition, direction)
	end

	return direction
end

return FaceReposition
