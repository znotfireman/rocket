local ButtonGroup = require("@src/components/foundations/ButtonGroup")
local Iris = require("@pkgs/Iris")
local pages = require("./pages")
local settings = require("@src/atoms/settings")

local function SettingsTabs()
	Iris.PushConfig({ TextTransparency = 0.5 })
	Iris.Text({ "Settings" })
	Iris.PopConfig()
	for _, page in pages do
		local button = ButtonGroup()
		button.Instance.Size = UDim2.fromScale(1, 0)

		Iris.Image({ page.tabIcon, UDim2.fromOffset(18, 18) })
		Iris.Text({ page.title })

		Iris.End()

		if button.clicked() then
			settings.currentPage(page)
		end
	end
end

return SettingsTabs
