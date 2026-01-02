local Selection = game:GetService("Selection")
local Workspace = game:GetService("Workspace")

local Extension = require("@src/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-camera",
	title = "Camera",
	description = "Camera utilities.",
	icon = { Image = assets.extensions.locations },
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "set-to-instance",
	title = "Set Camera To Instance",
	description = "Sets the camera's position to the last selected instance.",

	run = function()
		local camera = Workspace:FindFirstChildOfClass("Camera")
		if not camera then
			return
		end

		local selection = Selection:Get()
		local lastSelection = selection[#selection]

		if not lastSelection then
			return
		end

		if lastSelection:IsA("BasePart") then
			camera.CFrame = lastSelection.CFrame
		end
	end,
})

local function useWaypoints()
	local rocketFolder = Workspace:FindFirstChild("Rocket") :: Instance
	if not rocketFolder then
		rocketFolder = Instance.new("Folder")
		rocketFolder.Name = "Rocket"
		rocketFolder.Parent = Workspace
	end

	local extensionFolder = rocketFolder:FindFirstChild(ext._metadata.id) :: Instance
	if not extensionFolder then
		extensionFolder = Instance.new("Folder")
		extensionFolder.Name = ext._metadata.id
		extensionFolder.Parent = rocketFolder
	end

	local waypoints = extensionFolder:FindFirstChild("Waypoints") :: Instance
	if not waypoints then
		waypoints = Instance.new("Folder")
		waypoints.Name = "Waypoints"
		waypoints.Parent = extensionFolder
	end

	return waypoints
end

ext:newCommand({
	id = "save-waypoint",
	title = "Save Camera Waypoint Here",
	description = "Wow",

	run = function()
		local _waypoints = useWaypoints()
		Selection:Set({})
	end,
})

ext:newCommand({
	id = "list-waypoint",
	title = "List Camera Waypoints",
	description = "Wow",

	run = function()
		Selection:Set({})
	end,
})

return ext
