local Iris = require("@src/Iris")
local SettingsStore = require("@settings/SettingsStore")
local Theme = require("@theme/Theme")

local function SettingsContentNav()
	Iris.SameLine()
	Theme.push(Theme.presets.subtext)
	Iris.Text(SettingsStore.currentPage().title)
	Iris.PopConfig()
	Iris.FlexSpacer(Enum.UIFlexMode.Grow)
	if Iris.Button("Close").clicked() then
		SettingsStore.isVisible(false)
	end
	Iris.End()
end

local function SettingsContent()
	SettingsContentNav()
	SettingsStore.currentPage().render()
end

return SettingsContent
