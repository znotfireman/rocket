--#selene: allow(undefined_variable)

export type ID = string

export type State<T> = {
	ID: ID,
	value: T,
	lastChangeTick: number,
	ConnectedWidgets: { [ID]: Widget },
	ConnectedFunctions: { (newValue: T) -> () },

	get: (self: State<T>) -> T,
	set: (self: State<T>, newValue: T, force: true?) -> (),
	onChange: (self: State<T>, onChangeCallback: (newValue: T) -> ()) -> () -> (),
	changed: (self: State<T>) -> boolean,
}

export type function Statetify(states: type)
	assert(states.tag == "table", "expected table")

	for key, values in states:properties() do
		-- ur joking
		-- states:setproperty(key, State(values.read))

		local valueType = values.read
		assert(valueType, `value for state "{key}" cannot be write-only`)

		local connectedFunction = types.newfunction({ head = { valueType } })

		local state = types.newtable {
			[types.singleton("ID")] = types.string,
			[types.singleton("value")] = valueType,
			[types.singleton("lastChangeTick")] = types.number,
			[types.singleton("ConnectedWidgets")] = types.newtable({}, {
				index = types.number,

				-- TODO: how do we get the Widget type?
				-- ...I'm not going to build it by hand bro
				readresult = types.any,
				writeresult = types.any,
			}),
			[types.singleton("ConnectedFunctions")] = types.newtable({}, {
				index = types.string,
				readresult = connectedFunction,
				writeresult = connectedFunction,
			}),
		}

		state:setproperty(
			types.singleton("get"),
			types.newfunction({
				head = { state },
			}, { head = { valueType } })
		)

		state:setproperty(
			types.singleton("set"),
			types.newfunction({
				head = { state, valueType, types.optional(types.singleton(true)) },
			})
		)

		state:setproperty(
			types.singleton("onChange"),
			types.newfunction({
				head = { state, types.newfunction({ head = { valueType } }) },
			}, { head = { types.newfunction() } })
		)

		state:setproperty(
			types.singleton("changed"),
			types.newfunction({
				head = { state },
			}, { head = { types.boolean } })
		)

		states:setproperty(key, state)
	end

	return states
end

export type Widget<Arguments = {}, States = {}> = {
	ID: ID,
	type: string,
	lastCycleTick: number,
	trackedEvents: {},
	parentWidget: ParentWidget<Arguments, States>,

	arguments: Arguments,
	providedArguments: {},

	state: States,

	Instance: GuiObject,
	ZIndex: number,
}

export type ParentWidget<Arguments = {}, States = {}> = Widget<Arguments, States> & {
	ChildContainer: GuiObject,
	ZOffset: number,
	ZUpdate: boolean,
}

return nil
