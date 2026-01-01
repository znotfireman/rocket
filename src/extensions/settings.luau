local Extension = require("@src/lib/Extension")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-settings",
	title = "Rocket Settings",
	description = "Manage your Rocket Settings",
	icon = { Image = "" },
	authors = { "Team Fireworks" },
})

return ext
