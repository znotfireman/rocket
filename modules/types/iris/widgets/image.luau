local events = require("../events")
local types = require("../types")

export type Image =
	types.Widget<{
		Image: string,
		Size: UDim2,
		Rect: Rect?,
		ScaleType: Enum.ScaleType?,
		ResampleMode: Enum.ResamplerMode?,
		TileSize: UDim2?,
		SliceCenter: Rect?,
		SliceScale: number?,
	}>
	& events.Hovered

export type ImageButton =
	types.Widget<{
		Image: string,
		Size: UDim2,
		Rect: Rect?,
		ScaleType: Enum.ScaleType?,
		ResampleMode: Enum.ResamplerMode?,
		TileSize: UDim2?,
		SliceCenter: Rect?,
		SliceScale: number?,
	}>
	& events.Clicked
	& events.RightClicked
	& events.DoubleClicked
	& events.CtrlClicked
	& events.Hovered

return nil
