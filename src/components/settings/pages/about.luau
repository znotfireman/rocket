local assets = require("@src/assets")
local types = require("@src/components/settings/types")

local about = {} :: types.SettingPage
about.title = "About"
about.tabIcon = assets.icons.rocket

function about.render() end

return about
