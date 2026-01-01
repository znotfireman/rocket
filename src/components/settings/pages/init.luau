local types = require("./types")

local pages: { types.SettingPage } = {
	require("@self/extensions"),
	require("@self/about"),
}

return pages
