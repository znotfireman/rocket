local Iris = require("@src/Iris")
local assets = require("@src/assets")
local types = require("@settings/types")

local DebugPage = {} :: types.SettingsPage
DebugPage.id = "debug"
DebugPage.title = "Debug"
DebugPage.tabIcon = assets.icons.rocket
DebugPage.extensionIcon = assets.extensions.settings.about

function DebugPage.render()
	Iris.Text("TODO")
end

return DebugPage
