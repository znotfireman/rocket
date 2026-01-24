-- Iris new solver typings for Rocket based from upstream:
-- https://github.com/SirMallard/Iris/

local base = require("@self/types")
local basic = require("@self/widgets/basic")
local format = require("@self/widgets/format")
local image = require("@self/widgets/image")
local menu = require("@self/widgets/menu")
local tab = require("@self/widgets/tab")
local text = require("@self/widgets/text")
local tree = require("@self/widgets/tree")
local utils = require("./utils")
local window = require("@self/widgets/window")

-- TODO: Input, Drag, Slider, Plot, Combo, and Table widgets
export type Widgets = {
	Root: window.Root,
	Window: window.Window,
	Tooltip: window.Tooltip,

	Menu: menu.Menu,
	MenuBar: menu.MenuBar,
	MenuItem: menu.MenuItem,
	MenuToggle: menu.MenuToggle,

	Separator: format.Separator,
	Indent: format.Indent,
	SameLine: format.SameLine,
	Group: format.Group,

	Text: text.Text,
	SeparatorText: text.SeparatorText,
	InputText: text.InputText,

	Button: basic.Button,
	Checkbox: basic.Checkbox,
	RadioButton: basic.RadioButton,
	SmallButton: basic.SmallButton,

	CollapsingHeader: tree.CollapsingHeader,
	Tree: tree.Tree,

	TabBar: tab.TabBar,
	Tab: tab.Tab,

	Image: image.Image,
	ImageButton: image.ImageButton,
}

type IntersectionToTable<Intersection> = utils.IntersectionToTable<Intersection>

type function IntoArguments(widgets: type)
	assert(widgets.tag == "table", "expected table")
	local arguments = types.singleton("arguments")
	local result = types.newtable()

	for name, values in widgets:properties() do
		assert(name.tag == "singleton", `invalid key of tag {name.tag}`)

		local maybeWidget = values.read
		assert(maybeWidget, `widget "{name}" cannot be read-only`)
		local widgetTag = maybeWidget.tag
		local widget = if widgetTag == "table"
			then maybeWidget
			elseif widgetTag == "intersection" then IntersectionToTable(maybeWidget)
			else error(`unsupported widget of tag {widgetTag}`)

		local widgetKeys = types.newtable()

		local widgetArguments = widget:readproperty(arguments)
		if widgetArguments then
			assert(widgetArguments.tag == "table", `invalid widget arguments for "{widget}"`)

			for argument in widgetArguments:properties() do
				widgetKeys:setreadproperty(argument, types.number)
			end
		end

		result:setreadproperty(name, widgetKeys)
	end

	return result
end

type function IntoConstructors(widgets: type)
	assert(widgets.tag == "table", "expected table")

	local KEY_ARGUMENTS = types.singleton("arguments")
	local KEY_STATES = types.singleton("state")
	local KEY_VALUE = types.singleton("value")

	local TYPE_NIL = types.singleton(nil)
	local TYPE_WIDGET_ARGUMENTS = types.newtable(
		{},
		{ index = types.number, readresult = types.any, writeresult = types.any }
	)

	local result = types.newtable()

	for name, values in widgets:properties() do
		assert(name.tag == "singleton", `invalid key of tag {name.tag}`)

		local maybeWidget = values.read
		assert(maybeWidget, `widget "{name:value()}" cannot be read-only`)

		local widgetTag = maybeWidget.tag
		local widget = if widgetTag == "table"
			then maybeWidget
			elseif widgetTag == "intersection" then IntersectionToTable(maybeWidget)
			else error(`unsupported widget "{name:value()}" of tag {widgetTag}`)

		local parameters = {}

		local widgetArguments = widget:readproperty(KEY_ARGUMENTS)
		parameters[1] = if widgetArguments and next(widgetArguments:properties())
			then TYPE_WIDGET_ARGUMENTS
			else TYPE_NIL

		local widgetStates = widget:readproperty(KEY_STATES)
		local widgetStatesProperties = (
			widgetStates and widgetStates:properties()
		) :: { [type]: { read: type?, write: type? } }

		if widgetStates and next(widgetStatesProperties) then
			for stateName, stateValues in widgetStatesProperties do
				local state = stateValues.read
				assert(state, "state cannot be write-only")
				assert(state.tag == "table", `invalid state "{stateName:value()}" in widget "{name:value()}"`)

				local innerState = state:readproperty(KEY_VALUE)
				assert(innerState, "state missing value property")

				widgetStates:setproperty(stateName, types.unionof(innerState, state, TYPE_NIL))
			end

			parameters[2] = types.optional(widgetStates)
		else
			parameters[2] = TYPE_NIL
		end

		local realParameterLen = 0
		for _, parameter in parameters do
			if parameter.tag == "nil" or (parameter.tag == "singleton" and parameter:value() == nil) then
				break
			end

			realParameterLen += 1
		end

		local realParameters = table.move(parameters, 1, realParameterLen, 1, {})

		result:setreadproperty(name, types.newfunction({ head = realParameters }, { head = { widget } }))
	end

	return result
end

export type ID = base.ID
export type State<T> = base.State<T>
export type Widget<Arguments = {}, States = {}> = base.Widget<Arguments, States>
export type ParentWidget = base.ParentWidget

export type WidgetArguments = IntoArguments<Widgets>
export type WidgetConstructors = IntoConstructors<Widgets>
export type GetWidget<Name> = index<Widgets, Name>

export type Config = {}
export type PartialConfig = {}

export type Internal = {}

--[=[
	@class Iris
	@since 0.1.0
	@tag vendor:https://sirmallard.github.io/Iris/

	Iris is the immediate-mode GUI library used in Rocket. For more information,
	see Iris' documentation and API reference.

	Note that Rocket derives it's own typings for Iris that are usable with
	Luau's new solver. This enables stronger type-safety:

	```luau
	-- With the original Iris package, `Iris.Args` would not autocomplete, and
	-- the states argument will throw a type error not knowing that non-state
	-- values can be used.
	Iris.Window(
		{ "Hello Rocket", [Iris.Args.Window.NoMove] = true },
		{ position = UserInputService:GetMouseLocation() }
	)
	```

	Types from the Iris package will not align with types from the Rocket
	library. In particular, Rocket does not export individual widget types, and
	Rocket prefixes Iris types with "Iris".

	Types for widgets must be accessed by indexing the Widgets type:

	```luau
	type Window = index<Rocket.Widgets, "Window">

	-- alternatively
	type Window = Rocket.GetIrisWidget<"Window">
	```

	More convenient widget types may be considered in the future.

	@example Using Iris in a command

	```lua
	ext:newCommand({
		id = "show-demo-window",
		title = "Show Demo Window",
		description = "Shows Iris' demo window."
	}, function(r: Rocket.CommandRuntime)
		local Iris = r.Iris
		local output = r:newCommandOutput()

		function output.renderViewport()
			if Iris.Button({ "Stop Demo Window" }).clicked() then
				r:cleanup()
				return
			end

			Iris.ShowDemoWindow()
		end

		return output
	end)
	```
]=]
export type Iris = WidgetConstructors & {
	Internal: Internal,

	Args: WidgetArguments,
	Disabled: boolean,
	TemplateConfig: {
		colorDark: PartialConfig,
		colorLight: PartialConfig,
		sizeDefault: PartialConfig,
		sizeClear: PartialConfig,
		utilityDefault: PartialConfig,
	},

	Connect: (self: Iris, callback: () -> ()) -> () -> (),
	Append: (userInstance: Instance) -> (),
	ComputedState: <T, U>(state: State<T>, onChangeCallback: (stateValue: T) -> U) -> State<U>,
	End: () -> (),
	ForceRefresh: () -> (),
	Init: (
		parentInstance: Instance?,
		eventConnection: RBXScriptSignal | () -> () | false | nil,
		allowMultipleInits: boolean?
	) -> (),
	PopConfig: () -> (),
	PopID: () -> (),
	PushConfig: (deltaStyles: PartialConfig) -> (),
	PushId: (id: ID) -> (),
	SetNextWidgetID: (id: ID) -> (),
	ShowDemoWindow: () -> (),
	Shutdown: () -> (),
	State: (<T>(initialValue: T) -> State<T>) & (<T>() -> State<T?>),
	TableState: <K, V>(tbl: { [K]: V }, key: K, callback: ((newValue: V) -> false?)?) -> State<V>,
	UpdateGlobalConfig: (deltaStyle: PartialConfig) -> (),
	VariableState: <T>(variable: T, callback: (T) -> ()) -> State<T>,
	WeakState: <T>(initialValue: T) -> State<T>,
}

return nil
