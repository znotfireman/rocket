local events = require("../events")
local types = require("../types")

export type Button =
	types.Widget<{ Text: string, Size: UDim2? }>
	& events.Clicked
	& events.RightClicked
	& events.DoubleClicked
	& events.CtrlClicked
	& events.Hovered

export type Checkbox =
	types.Widget<{ Text: string }, { isChecked: types.State<boolean> }>
	& events.Checked
	& events.Unchecked
	& events.Hovered

export type RadioButton =
	types.Widget<{
		Text: string,
		Index: any,
	}, { index: types.State<any> }>
	& events.Selected
	& events.Unselected
	& events.Active
	& events.Hovered

export type SmallButton =
	types.Widget<{
		Text: string,
		Size: UDim2?,
	}>
	& events.Clicked
	& events.RightClicked
	& events.DoubleClicked
	& events.CtrlClicked
	& events.Hovered

return nil
