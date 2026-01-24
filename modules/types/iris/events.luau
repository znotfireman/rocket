export type Hovered = {
	isHoveredEvent: boolean,
	hovered: () -> boolean,
}

export type Clicked = {
	lastClickedTick: number,
	clicked: () -> boolean,
}

export type RightClicked = {
	lastRightClickedTick: number,
	rightClicked: () -> boolean,
}

export type DoubleClicked = {
	lastClickedTime: number,
	lastClickedPosition: Vector2,
	lastDoubleClickedTick: number,
	doubleClicked: () -> boolean,
}

export type CtrlClicked = {
	lastCtrlClickedTick: number,
	ctrlClicked: () -> boolean,
}

export type Active = {
	active: () -> boolean,
}

export type Checked = {
	lastCheckedTick: number,
	checked: () -> boolean,
}

export type Unchecked = {
	lastUncheckedTick: number,
	unchecked: () -> boolean,
}

export type Opened = {
	lastOpenedTick: number,
	opened: () -> boolean,
}

export type Closed = {
	lastClosedTick: number,
	closed: () -> boolean,
}

export type Collapsed = {
	lastCollapsedTick: number,
	collapsed: () -> boolean,
}

export type Uncollapsed = {
	lastUncollapsedTick: number,
	uncollapsed: () -> boolean,
}

export type Selected = {
	lastSelectedTick: number,
	selected: () -> boolean,
}

export type Unselected = {
	lastUnselectedTick: number,
	unselected: () -> boolean,
}

export type Changed = {
	lastChangedTick: number,
	changed: () -> boolean,
}

export type NumberChanged = {
	lastNumberChangedTick: number,
	numberChanged: () -> boolean,
}

export type TextChanged = {
	lastTextChangedTick: number,
	textChanged: () -> boolean,
}

return nil
