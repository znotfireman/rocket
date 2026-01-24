local types = require("./types")

local function compareModules(lhs: types.Module, rhs: types.Module)
	return lhs.name < rhs.name
end

return compareModules
