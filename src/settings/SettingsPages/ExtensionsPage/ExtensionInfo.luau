local Command = require("@src/Command")
local Iris = require("@iris/Iris")
local Theme = require("@theme/Theme")
local useExtensionPageState = require("./useExtensionPageState")

local function ExtensionInfo(state: useExtensionPageState.ExtensionPageState)
	local selected = state.selected:get()
	if not selected then
		return
	end

	local asCmd = selected :: Command.Command
	local isCommand = Command.is(asCmd)

	Iris.Spacer(8)
	Iris.SameLine(8, Enum.VerticalAlignment.Center)
	Iris.Icon(selected._metadata.icon or asCmd._extension._metadata.icon, UDim2.fromOffset(32, 32))
	Iris.Text(`<b>{selected._metadata.title}</b>`)
	Iris.End()

	Iris.SeparatorText("Description")
	Iris.Text(selected._metadata.description)

	Iris.SeparatorText("Preferences")
	Iris.Checkbox({ "Enabled" })
	if isCommand then
		Iris.Checkbox({ "Run on Startup" })
	end

	Iris.SeparatorText("Debug")
	Iris.PushConfig(Theme.presets.subtext)
	Iris.Text(`ID: {selected._metadata.id}`)
	if isCommand then
		Iris.Text(`Full ID: {asCmd:formatId()}`)
	end
	Iris.PopConfig()
end

return ExtensionInfo
