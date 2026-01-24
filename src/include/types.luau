-- darklua implodes if you use a type function bruv

-- selene: allow(undefined_variable)
export type function WidgetCall(widgetClass: type)
	local baseClass = if widgetClass.tag == "intersection" then widgetClass:components()[2] else widgetClass
	assert(baseClass.tag == "table", "expected widget class")

	local placeholder = types.singleton(nil)

	local arguments = baseClass:readproperty(types.singleton("arguments")) :: type
	if arguments then
		local properties = arguments:properties()
		if next(properties) == nil then
			arguments = placeholder
		else
			for key, value in properties do
				local valueRead = value.read
				assert(valueRead, `argument {key} cannot be write only`)
				arguments:setproperty(key, types.optional(valueRead))
			end
			arguments:setindexer(types.number, types.unknown)
		end
	end

	local state = baseClass:readproperty(types.singleton("state")) :: type
	if state then
		for key, value in state:properties() do
			local stateValue = value.read
			assert(stateValue, `state {key} cannot be write only`)
			state:setproperty(key, types.unionof(stateValue, types.unknown))
		end
		state:setindexer(types.number, types.unknown)
	end

	return types.newfunction(
		{ head = {
			arguments or placeholder,
			state or placeholder,
		} },
		{ head = { widgetClass } }
	)
end

return nil
