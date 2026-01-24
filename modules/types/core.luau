local arguments = require("./arguments")
local iris = require("./iris")
local log = require("./log")
local schemas = require("./schemas")
local trove = require("./vendor/trove")

export type RecordChangeHistoryOptions = {
	name: string?,
	displayName: string?,

	ignoreRobloxFailure: boolean?,
	hideRobloxFailure: boolean?,
	isCancellable: boolean?,
	cancelsOthers: boolean?,
}

export type CommandRuntimeSelf = {
	trove: trove.Trove,
	command: Command,
	log: log.Log,
}

export type CommandRuntimeMetatable = {
	__index: CommandRuntimeMetatable,
	__tostring: (self: CommandRuntime) -> string,

	Iris: iris.Iris,

	getTextArgument: (self: CommandRuntime, text: string) -> (),

	cleanup: (self: CommandRuntime) -> (),
	getSelection: (self: CommandRuntime) -> { Instance },
	setSelection: (self: CommandRuntime, instances: { Instance }) -> (),
	recordChangeHistory: (self: CommandRuntime, maybeOptions: RecordChangeHistoryOptions?) -> (),
}

export type CommandRuntime = setmetatable<CommandRuntimeSelf, CommandRuntimeMetatable>

---

export type CommandOutput = {
	renderViewport: () -> (),

	windowArgs: {},
	windowConfig: {},
	renderWindow: (window: any) -> (),
}

---

export type CommandSchema = {
	id: string,
	title: string,
	description: schemas.Description,
	icon: string?,
	contributors: { schemas.Contributor }?,
	arguments: { arguments.Argument }?,
}

export type CommandSelf = {
	extension: Extension,
	schema: CommandSchema,
}

export type CommandMetatable = {
	__index: CommandMetatable,
	__tostring: (self: Command) -> string,

	formatFullId: (self: Command) -> string,
}

export type Command = setmetatable<CommandSelf, CommandMetatable>

export type CommandRunner =
	| ((r: CommandRuntime) -> ())
	| ((r: CommandRuntime) -> CommandOutput)
	| ((r: CommandRuntime) -> CommandOutput?)

---

export type ExtensionCapabilities = {
	commands: {
		[string]: { reads: boolean, runs: boolean },
	},
}

export type ExtensionSchema = {
	id: string,
	title: string,
	description: schemas.Description,
	icon: string,
	contributors: { schemas.Contributor }?,
	capabilities: ExtensionCapabilities?,
}

export type ExtensionSelf = {
	trove: trove.Trove,
	schema: ExtensionSchema,
}

export type ExtensionMetatable = {
	__index: ExtensionMetatable,
	__tostring: (self: Extension) -> string,

	getCommands: (self: Extension) -> { Command },
	pushCommand: (self: Extension, command: Command) -> Command,
	newCommand: (self: Extension, schema: CommandSchema, runner: CommandRunner) -> Command,
}

export type Extension = setmetatable<ExtensionSelf, ExtensionMetatable>

---

--[=[
	@type FromExtension Extension | Command

	Products that an Extension can produce, which is usable with the Rocket
	plugin.
]=]
export type FromExtension = Extension | Command

return nil
