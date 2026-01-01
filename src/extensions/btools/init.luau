local Extension = require("@src/lib/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-btools",
	title = "Building Tools",
	description = "Rocket's Modern Suite of Building Tools",
	icon = { Image = assets.extensions.btools },
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "launch-btools",
	title = "Building Tools",
	description = "Launches Rocket's modern suite of building tools.",

	run = function() end,
})

return ext
