local schemas = require("./schemas")
local utils = require("./utils")

export type BaseArgument<Type> = {
	type: Type,

	name: string,
	description: schemas.Description,
	placeholder: string,
	required: boolean?,
}

export type TextArgument = utils.MergeTable<BaseArgument<"text">, {
	sensitive: boolean?,
}>

export type InstanceClassArgument = BaseArgument<"instance-class">

export type SelectArgumentOption = { title: string, value: string }
export type SelectArgument = utils.MergeTable<BaseArgument<"select">, {
	options: { SelectArgumentOption },
}>

export type Argument = TextArgument | InstanceClassArgument | SelectArgument

return nil
