local Extension = require("@src/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-reclass",
	title = "Reclass",
	description = "Lossless changing of instance classes.",
	icon = { Image = assets.extensions.rocket },
	authors = { "Team Fireworks" },
})

return ext
