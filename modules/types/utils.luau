--#selene: allow(undefined_variable)

export type function MergeTable(base: type, override: type)
	assert(base.tag == "table", "expected base to be a table")
	assert(override.tag == "table", "expected override to be a table")

	local result = types.newtable()
	for _, merge in { base, override } do
		for key, values in merge:properties() do
			if values.read and values.write then
				result:setproperty(key, values.read)
			elseif values.read then
				result:setreadproperty(key, values.read)
			elseif values.write then
				result:setreadproperty(key, values.write)
			end
		end
	end

	return result
end

export type function IntersectionToTable(intersection: type): type
	assert(intersection.tag == "intersection", "expected an intersection")

	local result = types.newtable()
	for index, component in intersection:components() do
		local merge = if component.tag == "intersection"
			then (IntersectionToTable(component) :: type):properties()
			elseif component.tag == "table" then component:properties()
			else error(`unsupported type "{component.tag}" in component #{index}`)

		for key, values in merge do
			if values.read and values.write then
				result:setproperty(key, values.read)
			elseif values.read then
				result:setreadproperty(key, values.read)
			elseif values.write then
				result:setreadproperty(key, values.write)
			end
		end
	end

	return result
end

return nil
