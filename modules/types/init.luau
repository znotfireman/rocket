-- NOTE: this module does not run through darklua so we can use type functions

local arguments = require("@self/arguments")
local core = require("@self/core")
local iris = require("@self/iris")
local log = require("@self/log")
local schemas = require("@self/schemas")
local utils = require("@self/utils")

export type FromExtension = core.FromExtension

export type Extension = core.Extension
export type ExtensionSelf = core.ExtensionSelf
export type ExtensionMetatable = core.ExtensionMetatable
export type ExtensionSchema = core.ExtensionSchema

export type Command = core.Command
export type CommandSelf = core.CommandSelf
export type CommandMetatable = core.CommandMetatable
export type CommandSchema = core.CommandSchema
export type CommandRunner = core.CommandRunner
export type CommandOutput = core.CommandOutput
export type CommandRuntime = core.CommandRuntime

export type BaseArgument<Type> = arguments.BaseArgument<Type>
export type TextArgument = arguments.TextArgument
export type InstanceClassArgument = arguments.InstanceClassArgument
export type SelectArgumentOption = arguments.SelectArgumentOption
export type SelectArgument = arguments.SelectArgument
export type Argument = arguments.Argument

export type Description = schemas.Description
export type UserContributor = schemas.UserContributor
export type CustomContributor = schemas.CustomContributor
export type Contributor = schemas.Contributor

export type Iris = iris.Iris
export type IrisWidgets = iris.Widgets
export type IrisWidget<Arguments = {}, States = {}> = iris.Widget<Arguments, States>
export type IrisState<T> = iris.State<T>
export type IrisConfig = iris.Config
export type IrisPartialConfig = iris.PartialConfig
export type GetIrisWidget<Name> = iris.GetWidget<Name>

export type Log = log.Log

export type MergeTable<Base, Overrides> = utils.MergeTable<Base, Overrides>
export type IntersectionToTable<Intersection> = utils.IntersectionToTable<Intersection>

--[=[
	@class Rocket
	@since 0.1.0

	The Rocket extension library, which is inserted by the Rocket plugin as
	the `game.Rocket` ModuleScript.

	Below is the recommended way to require Rocket:

	```lua
	local Rocket = require(game:WaitForChild("Rocket", math.huge))
	print(Rocket.version)
	```

	## Purpose

	This package only provides typings for the Rocket extension library. The
	static properties are inserted at runtime by the Rocket plugin.

	```lua
	-- Ignorance is strength, let's consume Rocket as a package!
	local Plugin = script:FindFirstAncestorOfClass("Plugin")
	local Rocket = require(Plugin.Packages.Rocket)

	-- This will error.
	local ext = Rocket:newExtension(...)
	```

	## Usage from Package Managers

	If you would like to access Rocket with a sync-tool like Rojo, you can
	either:

	1.  In your project file for your sync tool's sourcemap, such as Rojo, add
		an entry for `Rocket`:

		```jsonc
		// It is imperative this only exists in your sourcemap. You may make a
		// `sourcemap.project.json` file like below and generate a sourcemap
		// from that.
		//
		// Otherwise, this will override Rocket's actual extension library at
		// runtime, which would not end well.
		{
			"name": "My Plugin",
			"tree": {
				"$className": "DataModel"
				"Rocket": {
					"$path": "./roblox_packages/Rocket"
				},

				// Then, place your plugin somewhere else.
				"ServerScriptService": {
					"Plugin": {
						"$path": "./src"
					},
				}
			}
		}
		```

		Then require Rocket like in Studio:

		```lua
		local Rocket = require(game:WaitForChild("Rocket", math.huge))
		print(Rocket.version)
		```

	2.  Install Rocket's `pub` package with your preferred package manager,
		which wraps the require call above with	the library's types.
]=]
export type Rocket = {
	version: string,
	sessionId: string,

	isCommand: (x: unknown) -> boolean,
	isCommandRuntime: (x: unknown) -> boolean,
	isExtension: (x: unknown) -> boolean,

	useIris: (self: Rocket) -> iris.Iris?,
	useCurrentCommand: (self: Rocket) -> Command?,
	useCurrentCommandRuntime: (self: Rocket) -> CommandRuntime?,
	useCurrentExtension: (self: Rocket) -> Extension?,

	newExtension: (self: Rocket, plugin: Plugin, schema: ExtensionSchema) -> Extension,
}

return {} :: Rocket
