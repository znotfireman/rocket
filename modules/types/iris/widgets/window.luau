local events = require("../events")
local types = require("../types")

export type Root = types.ParentWidget

export type Window =
	types.Widget<{
		Title: string?,
		NoTitleBar: boolean?,
		NoBackground: boolean?,
		NoCollapse: boolean?,
		NoClose: boolean?,
		NoMove: boolean?,
		NoScrollbar: boolean?,
		NoResize: boolean?,
		NoNav: boolean?,
		NoMenu: boolean?,
	}, {
		size: types.State<Vector2>,
		position: types.State<Vector2>,
		isUncollapsed: types.State<boolean>,
		isOpened: types.State<boolean>,
		scrollDistance: types.State<number>,
	}>
	& events.Opened
	& events.Closed
	& events.Collapsed
	& events.Uncollapsed
	& events.Hovered

export type Tooltip = types.Widget<{ Text: string }>

return nil
