local configure = require("@monorepo/configure")
local path = require("@std/path")

export type Module = {
	name: string,
	relativePath: path.pathlike,
	configPath: path.pathlike,
	configRequirePath: path.pathlike,
	config: configure.ModuleConfig,
}

export type ModuleResult = {
	names: { string },
	modules: { Module },
	nameToModule: { [string]: Module },
}

return nil
