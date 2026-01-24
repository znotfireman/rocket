local types = require("../types")

export type Separator = types.Widget

export type Indent = types.ParentWidget<{
	Width: number?,
}>

export type SameLine = types.ParentWidget<{
	Width: number?,
	VerticalAlignment: Enum.VerticalAlignment?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
}>

export type Group = types.ParentWidget

return nil
