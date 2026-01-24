local events = require("../events")
local types = require("../types")

export type CollapsingHeader =
	types.Widget<{ Text: string, DefaultOpen: boolean? }, { isUncollapsed: types.State<boolean> }>
	& events.Collapsed
	& events.Uncollapsed
	& events.Hovered

export type Tree =
	types.Widget<
		{ Text: string, SpanAvailWidth: boolean?, NoIndent: boolean?, DefaultOpen: boolean? },
		{ isUncollapsed: types.State<boolean> }
	>
	& events.Collapsed
	& events.Uncollapsed
	& events.Hovered

return nil
