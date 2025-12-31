local Trove = require("@pkgs/Trove")

-- selene doesn't detect typeof() in types
-- selene: allow(unused_variable)
local Iris = require("@pkgs/Iris")

local Command = {}
Command.__index = Command

export type CommandContext = {
	trove: Trove.Trove,
	iris: typeof(Iris),
}

export type CommandMetadata = {
	id: string,
	title: string,
	description: string,
	icon: string?,

	run: (ctx: CommandContext) -> ()?,
	renderInViewport: (ctx: CommandContext) -> ()?,
	renderInLauncher: (ctx: CommandContext) -> ()?,
}

-- LUAU: extension is typed as any to prevent cyclic dependencies
export type Command = setmetatable<{
	_extension: any,
	_metadata: CommandMetadata,
}, typeof(Command)>

function Command.new(extension: any, metadata: CommandMetadata): Command
	return setmetatable({ _extension = extension, _metadata = metadata }, Command)
end

function Command.formatId(self: Command)
	return self._extension._metadata.id .. ":" .. self._metadata.id
end

function Command.sortByTitle(lhs: Command, rhs: Command)
	return lhs._metadata.title < rhs._metadata.title
end

function Command.__tostring(self: Command)
	return `Command({string.format("%q", self:formatId())})`
end

return table.freeze(Command)
