local Extension = require("@src/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-tags",
	title = "Tags",
	description = "TBA",
	icon = { Image = assets.extensions.rocket },
	authors = { "Team Fireworks" },
})

return ext
