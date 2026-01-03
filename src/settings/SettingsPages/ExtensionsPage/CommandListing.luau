local Command = require("@src/Command")
local Iris = require("@src/Iris")
local useExtensionPageState = require("./useExtensionPageState")

local function CommandListing(cmd: Command.Command, state: useExtensionPageState.ExtensionPageState)
	local group = Iris.ButtonGroup(UDim2.fromScale(1, 0))
	if group.clicked() then
		state.selected:set(cmd)
	end
	Iris.Icon(cmd._metadata.icon or cmd._extension._metadata.icon, UDim2.fromOffset(18, 18))
	Iris.Text(cmd._metadata.title)
	Iris.End()
	return group
end

return CommandListing
