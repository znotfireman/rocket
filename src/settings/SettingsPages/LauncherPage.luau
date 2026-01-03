local Iris = require("@src/Iris")
local assets = require("@src/assets")
local types = require("@settings/types")

local LauncherPage = {} :: types.SettingsPage
LauncherPage.id = "launcher"
LauncherPage.title = "Launcher"
LauncherPage.tabIcon = assets.icons.rocket
LauncherPage.extensionIcon = assets.extensions.settings.about

function LauncherPage.render()
	Iris.Text("TODO")
end

return LauncherPage
