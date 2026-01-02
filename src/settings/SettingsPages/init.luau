local types = require("./types")

local SettingsPages: { types.SettingsPage } = {
	require("@self/ExtensionsPage"),
	require("@self/LauncherPage"),
	require("@self/AppearancePage"),
	require("@self/AboutPage"),
	require("@self/DebugPage"),
}

return SettingsPages
