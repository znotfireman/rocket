local Iris = require("@src/Iris")
local Theme = require("@theme/Theme")
local useExtensionPageState = require("./useExtensionPageState")

local function ExtensionListToolbar(state: useExtensionPageState.ExtensionPageState)
	local config = Theme.config()
	Theme.push({
		CellPadding = config.CellPadding,
		WindowPadding = config.WindowPadding,
		ItemSpacing = config.WindowPadding,
	})

	Iris.SameLine()

	Iris.Menu({ "Toggle All" })
	if Iris.MenuItem("Uncollasped").clicked() then
		state.massCollapse:set(false)
	end
	if Iris.MenuItem("Collasped").clicked() then
		state.massCollapse:set(true)
	end
	Iris.End()

	Iris.Menu({ "Filters" })
	Iris.MenuToggle({ "Show Enabled Extensions" }, { isChecked = state.showEnabled })
	Iris.MenuToggle({ "Show Disabled Extensions" }, { isChecked = state.showDisabled })
	Iris.Separator()
	Iris.MenuToggle({ "Show Core Extensions" }, { isChecked = state.showCore })
	Iris.MenuToggle({ "Show Third-Party Extensions" }, { isChecked = state.showThirdParty })
	Iris.End()
	Iris.InputText({ "", "Search commands..." })

	Iris.End()
	Iris.PopConfig()
end

return ExtensionListToolbar
