local Iris = require("@pkgs/Iris")
local Theme = require("@theme/Theme")

local function Subtext(text: string)
	Theme.push(Theme.presets.subtext)
	local widget = Iris.Text({ text })
	Theme.pop()
	return widget
end

return Subtext
