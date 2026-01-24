local events = require("../events")
local types = require("../types")

export type Text =
	types.Widget<{
		Text: string?,
		Wrapped: boolean?,
		Color: Color3?,
		RichText: boolean?,
	}>
	& events.Hovered

export type SeparatorText = types.Widget<{ Text: string? }> & events.Hovered

export type InputText =
	types.Widget<
		{ Text: string?, TextHint: string?, ReadOnly: string?, MultiLine: string? },
		{ text: types.State<string> }
	>
	& events.Hovered
	& events.TextChanged

return nil
