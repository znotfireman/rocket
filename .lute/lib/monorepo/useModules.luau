local compareModules = require("@monorepo/compareModules")
local configure = require("@monorepo/configure")
local cwdrequire = require("@lib/utils/requireCwd")
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")
local types = require("@monorepo/types")

local function useModules(repository: configure.RepositoryConfig): types.ModuleResult
	local names: { string } = {}
	local modules: { types.Module } = {}
	local nameToModule: { [string]: types.Module } = {}

	local modulesDir = repository.modules.dir
	for _, module in fs.listdirectory(modulesDir) do
		local moduleName: string = module.name
		local modulePath = path.join(modulesDir, moduleName)
		local moduleConfigRequirePath = path.join(modulePath, "__config__")
		local moduleConfigRealPath = path.join(modulePath, "__config__.luau")

		if not fs.exists(moduleConfigRealPath) then
			continue
		end

		print(`Requiring module {moduleName}`, `(path: {modulePath})`)

		local requireSucess, configOrError = pcall(cwdrequire, moduleConfigRequirePath)
		if not requireSucess then
			print(`Failed to require configuration for module {moduleName}`, `(path: {modulePath}):`)
			print(configOrError)
			return process.exit(1)
		end

		local configResult = configure.ModuleConfig:match(configOrError)
		if configResult.ok then
			local self: types.Module = {
				name = moduleName,
				relativePath = modulePath,
				configPath = moduleConfigRealPath,
				configRequirePath = moduleConfigRequirePath,
				config = configOrError,
			}

			table.insert(names, moduleName)
			table.insert(modules, self)
			nameToModule[moduleName] = self
			continue
		end

		print(`Failed to require configuration for module {moduleName}`, `(path: {modulePath}):`)
		print(configResult:format())
		return process.exit(1)
	end

	table.sort(names)
	table.sort(modules, compareModules)
	return { names = names, modules = modules, nameToModule = nameToModule }
end

return useModules
