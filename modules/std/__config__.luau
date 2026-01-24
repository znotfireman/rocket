local configure = require("@monorepo/configure")

return configure.module {
	name = "std",
	description = "Rocket Plugin's complementary Standard Library for Extensions",

	dependencies = {
		api = true,
		boba = true,
	},
}
