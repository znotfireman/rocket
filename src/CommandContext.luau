local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Gizmos = require("@src/Gizmos")
local Iris = require("@src/Iris")
local Trove = require("@pkgs/Trove")

local CommandContext = {}
CommandContext.__index = CommandContext
CommandContext.iris = Iris
CommandContext.gizmos = Gizmos

-- LUAU: command is typed any to avoid circular requires
export type CommandContext = setmetatable<{
	command: any,
	trove: Trove.Trove,
	mouse: PluginMouse,
}, typeof(CommandContext)>

function CommandContext.new(command: any, plugin: Plugin, trove: Trove.Trove): CommandContext
	return setmetatable({ command = command, trove = trove, mouse = plugin:GetMouse() }, CommandContext)
end

function CommandContext.recordChanges(self: CommandContext, id: string, title: string?)
	local changeId = ChangeHistoryService:TryBeginRecording(
		self.command:formatId() .. "/" .. id,
		if title then `Rocket - {self.command._metadata.title}: {title}` else `Rocket: {self.command._metadata.title}`
	)

	if changeId then
		self.trove:Add(function()
			ChangeHistoryService:FinishRecording(changeId, Enum.FinishRecordingOperation.Commit)
		end)
	end
end

function CommandContext.__tostring(self: CommandContext)
	return `CommandContext({string.format("%q", self.command:formatId())})`
end

return table.freeze(CommandContext)
