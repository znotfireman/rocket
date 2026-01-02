local Command = require("@src/Command")
local Extension = require("@src/Extension")
local Iris = require("@iris/Iris")

local function useExtensionPageState()
	return {
		showEnabled = Iris.State(true),
		showDisabled = Iris.State(true),
		showCore = Iris.State(true),
		showThirdParty = Iris.State(true),

		massCollapse = Iris.State(nil :: boolean?),
		extensionsCollapsed = Iris.State({} :: { [Extension.Extension]: true }),

		selected = Iris.State(nil :: nil | Extension.Extension | Command.Command),
	}
end

export type ExtensionPageState = typeof(useExtensionPageState())

return useExtensionPageState
