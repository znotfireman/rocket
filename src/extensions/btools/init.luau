local Extension = require("@src/lib/Extension")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-btools",
	title = "Building Tools",
	description = "Rocket's Modern Suite of Building Tools",
	icon = "",
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "launch-btools",
	title = "Building Tools",
	description = "Launches Rocket's modern suite of building tools.",

	run = function() end,

	renderInViewport = function(ctx: Extension.CommandContext)
		ctx.iris.Text({ "Hello World" })
	end,
})

return ext
