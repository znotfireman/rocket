local Charm = require("@pkgs/Charm")
local Command = require("./Command")
local plugin = script:FindFirstAncestorWhichIsA("Plugin")

export type CommandContext = Command.CommandContext

local Extension = {}
Extension.__index = Extension

Extension.allExtensions = Charm.atom({} :: { [Extension]: true })

Extension.allCommands = Charm.computed(function(): { Command.Command }
	local result = {}
	for extension in Extension.allExtensions() do
		table.move(extension._commands, 1, #extension._commands, #result + 1, result)
	end
	table.sort(result, Command.sortByTitle)
	return result
end)

Extension.commandTitles = Charm.computed(function(): { string }
	local allCommands = Extension.allCommands()
	local result = table.create(#allCommands) :: { string }
	for i, cmd in allCommands do
		result[i] = cmd._metadata.title
	end
	return result
end)

Extension.extensionsById = Charm.computed(function(): { [string]: Extension }
	local result = {}
	for extension in Extension.allExtensions() do
		result[extension._metadata.id] = extension
	end
	return result
end)

export type ExtensionMetadata = {
	id: string,
	title: string,
	description: string,
	icon: string,
	authors: { string },
}

export type Extension = setmetatable<{
	read _plugin: Plugin,
	read _metadata: ExtensionMetadata,
	read _commands: { Command.Command },
}, typeof(Extension)>

-- TODO: flow to validate third party plugins
function Extension.new(extPlugin: Plugin, extMetadata: ExtensionMetadata): Extension
	local self = setmetatable({ _plugin = extPlugin, _metadata = extMetadata, _commands = {} }, Extension)
	local allExtensions = table.clone(Extension.allExtensions())
	allExtensions[self] = true
	Extension.allExtensions(allExtensions)
	return table.freeze(self)
end

function Extension.isCore(self: Extension)
	return self._plugin == plugin
end

function Extension.newCommand(self: Extension, commandMetadata: Command.CommandMetadata)
	local command = Command.new(self, commandMetadata)
	table.insert(self._commands, command)
end

function Extension.destroy(self: Extension)
	local allExtensions = table.clone(Extension.allExtensions())
	allExtensions[self] = nil
	Extension.allExtensions(allExtensions)
end

function Extension.__tostring(self: Extension)
	return `Extension({string.format("%q", self._metadata.id)})`
end

return table.freeze(Extension)
