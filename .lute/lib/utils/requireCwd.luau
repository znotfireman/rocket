local path = require("@std/path")

local function requireCwd(modulePath: string)
	return (require)(path.format(path.join("..", "..", "..", modulePath)))
end

return requireCwd
