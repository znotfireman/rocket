local events = require("../events")
local types = require("../types")

export type MenuBar = types.ParentWidget

export type Menu = types.Widget<{ Text: string? }, { isOpened: types.State<boolean> }>

export type MenuItem = types.Widget<{
	Text: string,
	KeyCode: Enum.KeyCode?,
	ModifierKey: Enum.ModifierKey?,
}>

export type MenuToggle =
	types.Widget<{
		Text: string,
		KeyCode: Enum.KeyCode?,
		ModifierKey: Enum.ModifierKey?,
	}, { isChecked: types.State<boolean> }>
	& events.Checked
	& events.Unchecked
	& events.Hovered

return nil
