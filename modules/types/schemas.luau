local utils = require("./utils")

export type Description = nil | string | {
	brief: string?,
	long: string?,
}

export type BaseContributor<Type> = {
	type: Type,
}

export type UserContributor = utils.MergeTable<BaseContributor<"user">, {
	id: number,
}>

export type CustomContributor = utils.MergeTable<BaseContributor<"custom">, {
	image: number,
	title: number,
}>

export type Contributor = UserContributor | CustomContributor

return nil
