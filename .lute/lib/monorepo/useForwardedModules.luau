local compareModules = require("./compareModules")
local process = require("@lute/process")
local types = require("./types")

local function useForwardedModules(modules: types.ModuleResult, forwarded: { string }?): { types.Module }
	local targetModules: { types.Module }

	if forwarded then
		local countForwarded = #forwarded
		if countForwarded > 0 then
			targetModules = table.create(#forwarded) :: { types.Module }
			for _, moduleName in forwarded do
				local module = modules.nameToModule[moduleName]
				if module then
					table.insert(targetModules, module)
					continue
				end

				print(`Unknown module named {moduleName}`)
				print(`Valid modules: {table.concat(modules.names)}`)
				return process.exit(1)
			end
			table.sort(targetModules, compareModules)
			return targetModules
		end
	end

	local countModules = #modules.modules
	targetModules = table.move(modules.modules, 1, countModules, 1, table.create(#modules.modules) :: any)
	return targetModules
end

return useForwardedModules
