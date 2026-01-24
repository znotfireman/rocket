local Boba = require("@modules/boba")

local function newStringLiteral<T>(str: T | ""): Boba.Boba<T>
	return Boba.Literal(str)
end

local ModuleName = newStringLiteral("api")
	:Or(newStringLiteral("boba"))
	:Or(newStringLiteral("std"))
	:Or(newStringLiteral("types"))
	:Nickname("ModuleName")

local ModuleConfig = Boba.Struct {
	name = ModuleName.inner,
	description = Boba.String.inner,

	repository = Boba.String:Optional().inner,
	documentation = Boba.String:Optional().inner,

	authors = Boba.String:Array():Optional().inner,
	license = Boba.String:Optional().inner,
	version = Boba.String:Optional().inner,
	private = Boba.Boolean:Optional().inner,

	dependencies = ModuleName:Map(Boba.Boolean):Optional().inner,
}:Nickname("ModuleConfig")

local ModuleRegistry = Boba.Struct {
	scope = Boba.String.inner,
	registry = Boba.String:Optional().inner,
	moduleFormat = Boba.String:Optional().inner,
}:Nickname("ModuleRegistry")

local RepositoryConfig = Boba.Struct {
	metadata = Boba.Struct {
		repository = Boba.String.inner,
		documentation = Boba.String.inner,

		authors = Boba.String:Array().inner,
		license = Boba.String.inner,
		version = Boba.String.inner,
		copyright = Boba.String.inner,
	}.inner,

	modules = Boba.Struct {
		dir = Boba.String.inner,

		registries = Boba.Struct {
			pesde = ModuleRegistry:Optional().inner,
			wally = ModuleRegistry:Optional().inner,
			npm = ModuleRegistry:Optional().inner,
		}
			:Optional().inner,
	}.inner,

	build = Boba.Struct {
		src = Boba.String.inner,
		extensions = Boba.String.inner,

		output = Boba.String.inner,
		model = Boba.String.inner,
		project = Boba.String.inner,
	}.inner,

	sourcemap = Boba.Struct {
		filename = Boba.String.inner,
		project = Boba.String.inner,
	}.inner,
}:Nickname("RepositoryConfig")

export type ModuleName = typeof(ModuleName.inner)
export type ModuleConfig = typeof(ModuleConfig.inner)
export type ModuleRegistry = typeof(ModuleRegistry.inner)
export type RepositoryConfig = typeof(RepositoryConfig.inner)

local function module(x: ModuleConfig)
	return ModuleConfig:assert(x)
end

local function repository(x: RepositoryConfig)
	return RepositoryConfig:assert(x)
end

return table.freeze({
	ModuleName = ModuleName,
	ModuleConfig = ModuleConfig,
	ModuleRegistry = ModuleRegistry,
	RepositoryConfig = RepositoryConfig,

	module = module,
	repository = repository,
})
