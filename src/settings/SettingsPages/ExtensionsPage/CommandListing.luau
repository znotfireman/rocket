local Command = require("@src/Command")
local Iris = require("@iris/Iris")
local useExtensionPageState = require("./useExtensionPageState")

local function CommandListing(cmd: Command.Command, state: useExtensionPageState.ExtensionPageState)
	if Iris.ButtonGroup(UDim2.fromScale(1, 0)).clicked() then
		state.selected:set(cmd)
	end
	Iris.Icon(cmd._metadata.icon or cmd._extension._metadata.icon, UDim2.fromOffset(18, 18))
	Iris.Text(cmd._metadata.title)
	Iris.End()
end

return CommandListing
