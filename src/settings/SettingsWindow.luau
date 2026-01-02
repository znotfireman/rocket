local Iris = require("@pkgs/Iris")
local SettingsContent = require("@settings/SettingsContent")
local SettingsSidebar = require("@settings/SettingsSidebar")
local SettingsStore = require("@settings/SettingsStore")
local useViewportSize = require("@src/utils/useViewportSize")

local SIDEBAR_WIDTH = 200
local WINDOW_ARGS = {
	"Rocket Settings",
	true, -- NoTitleBar
	false, -- NoBackground
	true, -- NoCollapse
	true, -- NoClose
	true, -- NoMove
	true, -- NoScrollbar
	true, -- NoResize
	false, -- NoNav
	false, -- NoMenu
}

local function SettingsWindow()
	Iris.PushConfig({
		WindowPadding = Vector2.zero,
		CellPadding = Iris._config.CellPadding * 2,
	})

	local viewportSize = useViewportSize()
	local windowSize = viewportSize * 0.8
	local windowState: any = { position = (viewportSize - windowSize) / 2, size = windowSize }
	if Iris.Window(WINDOW_ARGS, windowState).closed() then
		SettingsStore.isVisible(false)
		Iris.End()
		Iris.PopConfig()
		return
	end

	local layout = Iris.Table({ 2, false, false, false, true, true, true })
	layout.state.widths:set({ SIDEBAR_WIDTH, windowSize.X - SIDEBAR_WIDTH })
	layout.Instance.Size = UDim2.new(layout.Instance.Size.X.Scale, layout.Instance.Size.X.Offset, 1, 0)
		- UDim2.fromOffset(0, Iris._config.CellPadding.Y)
	SettingsSidebar()
	Iris.NextColumn()
	SettingsContent()
	Iris.End()

	Iris.End()
	Iris.PopConfig()
end

return SettingsWindow
