local configure = require("@monorepo/configure")

return configure.repository {
	metadata = {
		repository = "https://github.com/teamfireworks/rocket",
		documentation = "https://rocket.luau.page",

		authors = { "Team Fireworks" },
		license = "MPL-2.0",
		version = "0.0.0",
		copyright = "Copyright (c) 2025–2026 The Rocket Authors",
	},

	modules = {
		dir = "modules",
		registries = {
			npm = { scope = "rbxts", moduleFormat = "rocket-%s" },
			pesde = { scope = "team_fireworks", moduleFormat = "rocket_%s" },
			wally = { scope = "team-fireworks", moduleFormat = "rocket-%s" },
		},
	},

	build = {
		src = "src",
		extensions = "extensions",

		output = "out",
		project = "build.project.json",
		model = "Rocket.rbxm",
	},

	sourcemap = {
		filename = "sourcemap.json",
		project = "default.project.json",
	},
}
