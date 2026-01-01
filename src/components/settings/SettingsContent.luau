local Iris = require("@pkgs/Iris")
local Spacer = require("@src/components/foundations/Spacer")
local assets = require("@src/assets")
local settings = require("@src/atoms/settings")

local function SettingsContent()
	local currentPage = settings.currentPage()
	Iris.SameLine()
	Iris.PushConfig({ TextTransparency = 0.5 })
	Iris.Text({ currentPage.title })
	Iris.PopConfig()
	Spacer(Enum.UIFlexMode.Grow)
	if Iris.ImageButton({ assets.icons.x, UDim2.fromOffset(12, 12) }).clicked() then
		settings.isVisible(false)
	end
	Iris.End()

	currentPage.render()
end

return SettingsContent
