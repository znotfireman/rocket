local Charm = require("@pkgs/Charm")
local pages = require("@src/components/settings/pages")

local settings = {}
settings.isVisible = Charm.atom(false)
settings.currentPage = Charm.atom(pages[1])

return settings
