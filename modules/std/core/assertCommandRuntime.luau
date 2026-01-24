local Rocket = require("@modules/api")

local function assertCommandRuntime(api: string?)
	local r = Rocket:useCurrentCommandRuntime()
	if r then
		return r
	end

	local errorMessage = if api
		then `{api} can only be used inside a command.`
		else "This can only be called inside a command."

	error(errorMessage, 2)
end

return assertCommandRuntime
