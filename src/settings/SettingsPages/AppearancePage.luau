local Iris = require("@src/Iris")
local assets = require("@src/assets")
local types = require("@settings/types")

local ApperancePage = {} :: types.SettingsPage
ApperancePage.id = "appearance"
ApperancePage.title = "Appearance"
ApperancePage.tabIcon = assets.icons.rocket
ApperancePage.extensionIcon = assets.extensions.settings.about

function ApperancePage.render()
	Iris.Text("TODO")
end

return ApperancePage
