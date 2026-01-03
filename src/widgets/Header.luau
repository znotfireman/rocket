local Iris = require("@pkgs/Iris")
local Theme = require("@theme/Theme")

local function Header(text: string)
	Theme.push(Theme.presets.header)
	local widget = Iris.Text({ `<b>{text}</b>` })
	Theme.pop()
	return widget
end

return Header
