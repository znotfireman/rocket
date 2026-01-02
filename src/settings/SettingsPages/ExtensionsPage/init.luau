local ExtensionInfo = require("@self/ExtensionInfo")
local ExtensionList = require("@self/ExtensionList")
local ExtensionListToolbar = require("@self/ExtensionListToolbar")
local Iris = require("@iris/Iris")
local assets = require("@src/assets")
local types = require("@settings/types")
local useExtensionPageState = require("@self/useExtensionPageState")

local ExtensionsPage = {} :: types.SettingsPage
ExtensionsPage.id = "extensions"
ExtensionsPage.title = "Extensions"
ExtensionsPage.tabIcon = assets.icons.extension
ExtensionsPage.extensionIcon = assets.extensions.settings.extensions

function ExtensionsPage.render()
	local state = useExtensionPageState()

	ExtensionListToolbar(state)
	Iris.Separator()

	Iris.SameLine()
	Iris.Flex(Enum.UIFlexMode.Fill)

	Iris.ScrollingFrame(UDim2.fromScale(0.5, 1), Enum.AutomaticSize.None)
	ExtensionList(state)
	Iris.End()

	Iris.Separator()

	Iris.Frame(UDim2.fromScale(0.5, 0), Enum.AutomaticSize.Y)
	ExtensionInfo(state)
	Iris.End()

	Iris.End()
end

return ExtensionsPage
