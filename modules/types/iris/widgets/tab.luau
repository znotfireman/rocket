local events = require("../events")
local types = require("../types")

export type TabBar = types.ParentWidget<{}, {
	index: types.State<number>,
}>

export type Tab =
	types.Widget<{
		Text: string,
		Hideable: boolean?,
	}, {
		isOpened: types.State<boolean>,
	}>
	& events.Clicked
	& events.Hovered
	& events.Selected
	& events.Unselected
	& events.Active
	& events.Opened
	& events.Closed

return nil
