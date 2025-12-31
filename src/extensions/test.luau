local Extension = require("@src/lib/Extension")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-test",
	title = "Test",
	description = "Test extension",
	icon = "",
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "test-1",
	title = "Test Run",
	description = "Wow",

	run = function()
		print("Wow")
	end,
})

ext:newCommand({
	id = "test-2",
	title = "Test Render Palette",
	description = "Wow",

	renderInLauncher = function(ctx: Extension.CommandContext)
		if ctx.iris.Button({ "Ni Hao" }).clicked() then
			ctx.trove:Clean()
		end
	end,
})

ext:newCommand({
	id = "hello-world",
	title = "Test Render Viewport",
	description = "Wow",

	run = function() end,

	renderInViewport = function(ctx: Extension.CommandContext)
		if ctx.iris.Button({ "Hello World" }).clicked() then
			ctx.trove:Clean()
		end
	end,
})

return ext
