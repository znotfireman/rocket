local Command = require("@src/Command")
local CommandListing = require("./CommandListing")
local Extension = require("@src/Extension")
local ExtensionListing = require("./ExtensionListing")
local Iris = require("@iris/Iris")
local Theme = require("@theme/Theme")
local useExtensionPageState = require("./useExtensionPageState")

local function getRowThemePreset(
	row: number,
	state: useExtensionPageState.ExtensionPageState,
	selectable: Extension.Extension | Command.Command
)
	if state.selected:get() == selectable then
		return Theme.presets.button.selected
	end

	return if row % 2 == 0 then Theme.presets.button.unhighlighted else Theme.presets.button.highlighted
end

local function ExtensionList(state: useExtensionPageState.ExtensionPageState)
	local extensionsCollapsed = table.clone(state.extensionsCollapsed:get())
	local row = 1

	for i, extension in Extension.sortedByTitle() do
		local isCoreExtension = extension:isCore()
		if not (state.showCore:get() and isCoreExtension) then
			continue
		elseif state.showThirdParty:get() and not isCoreExtension then
			continue
		end

		row += 1

		local massCollapse = state.massCollapse:get()
		if massCollapse ~= nil then
			extensionsCollapsed[extension] = massCollapse or nil
		end

		local layoutOrder = i * 100
		Theme.push(getRowThemePreset(row, state, extension))
		ExtensionListing(extension, extensionsCollapsed, state, layoutOrder)
		Theme.pop()

		if extensionsCollapsed[extension] then
			continue
		end

		Iris.PushId(extension._metadata.id .. "/commands")
		Iris.Indent().Instance.LayoutOrder = layoutOrder + 1
		if next(extension._commands) == nil then
			Iris.Text("<i>This extension has no commands.</i>")
		else
			for _, cmd in extension._commands do
				row += 1
				Iris.PushId(cmd:formatId())
				Theme.push(getRowThemePreset(row, state, cmd))
				CommandListing(cmd, state)
				Theme.pop()
				Iris.PopId()
			end
		end
		Iris.End()
		Iris.PopId()
	end
	state.extensionsCollapsed:set(extensionsCollapsed)
end

return ExtensionList
