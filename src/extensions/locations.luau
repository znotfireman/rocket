local Selection = game:GetService("Selection")

local Extension = require("@src/lib/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-location",
	title = "Location",
	description = "Save and restore camera locations",
	icon = { Image = assets.extensions.locations },
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "save",
	title = "Save Location Here",
	description = "Wow",

	run = function()
		Selection:Set({})
	end,
})

ext:newCommand({
	id = "goto",
	title = "Go To Location",
	description = "Wow",

	run = function()
		Selection:Set({})
	end,
})

return ext
