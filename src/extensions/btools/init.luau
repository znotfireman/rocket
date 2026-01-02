local Extension = require("@src/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-btools",
	title = "Building Tools",
	description = "Rocket's modern suite of building tools.",
	icon = { Image = assets.extensions.btools },
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "launch-btools",
	title = "Building Tools",
	description = "Launches Rocket's modern suite of building tools.",

	run = function() end,
	renderInViewport = function(ctx: Extension.CommandContext)
		ctx.iris.SameLine()

		if ctx.iris.Button("Close").clicked() then
			ctx.trove:Clean()
		end

		ctx.iris.End()
	end,
})

return ext
