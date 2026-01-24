local configure = require("@monorepo/configure")

return configure.module {
	name = "api",
	description = "Wraps the Rocket Plugin's Extension API with types",

	dependencies = {
		types = true,
	},
}
