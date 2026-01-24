local types = require("./types")

export type FromExtension = types.FromExtension

export type Extension = types.Extension
export type ExtensionSelf = types.ExtensionSelf
export type ExtensionMetatable = types.ExtensionMetatable
export type ExtensionSchema = types.ExtensionSchema

export type Command = types.Command
export type CommandSelf = types.CommandSelf
export type CommandMetatable = types.CommandMetatable
export type CommandSchema = types.CommandSchema
export type CommandRunner = types.CommandRunner
export type CommandOutput = types.CommandOutput
export type CommandRuntime = types.CommandRuntime

export type BaseArgument<Type> = types.BaseArgument<Type>
export type TextArgument = types.TextArgument
export type InstanceClassArgument = types.InstanceClassArgument
export type SelectArgumentOption = types.SelectArgumentOption
export type SelectArgument = types.SelectArgument
export type Argument = types.Argument

export type Description = types.Description
export type UserContributor = types.UserContributor
export type CustomContributor = types.CustomContributor
export type Contributor = types.Contributor

export type Iris = types.Iris
export type IrisWidgets = types.IrisWidgets
export type IrisWidget<types = {}, States = {}> = types.IrisWidget<types, States>
export type IrisState<T> = types.IrisState<T>
export type IrisConfig = types.IrisConfig
export type IrisPartialConfig = types.IrisPartialConfig
export type GetIrisWidget<Name> = types.GetIrisWidget<Name>

export type MergeTable<Base, Overrides> = types.MergeTable<Base, Overrides>
export type IntersectionToTable<Intersection> = types.IntersectionToTable<Intersection>

--[=[
	@class Rocket
	@since 0.0.0

	The Rocket extension library.

	See the `types` package for more information.

	```lua
	local Rocket = require(plugin.Packages.Rocket)
	```
]=]
local Rocket: types.Rocket = (require)(game:WaitForChild("Rocket", math.huge))

return Rocket
