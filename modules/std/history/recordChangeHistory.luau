local ChangeHistoryService = game:GetService("ChangeHistoryService")
local RunService = game:GetService("RunService")

local assertCommandRuntime = require("@modules/std/core/assertCommandRuntime")

export type RecordChangeHistoryOptions = {
	name: string?,
	displayName: string?,

	ignoreRobloxFailure: boolean?,
	hideRobloxFailure: boolean?,
	isCancellable: boolean?,
	cancelsOthers: boolean?,

	hideToast: boolean?,
}

local function recordChangeHistory(
	recordingOptions: RecordChangeHistoryOptions?
): (operation: Enum.FinishRecordingOperation?) -> ()
	local r = assertCommandRuntime("recordChangeHistory")

	local options = recordingOptions or {} :: never

	local name = if options.name then `{r.command:formatFullId()}/{options.name}` else r.command:formatFullId()
	local displayName = "Rocket: "
		.. if options.displayName then `{r.command.schema.title} - {options.displayName}` else r.command.schema.title

	local success, id: string? = pcall(ChangeHistoryService.TryBeginRecording, ChangeHistoryService, name, displayName)

	if id == nil then
		if not options.hideRobloxFailure then
			local reason = if not success
				then "Roblox failed to begin recording the action"
				elseif ChangeHistoryService:IsRecordingInProgress() then "an undo-able action is still running"
				elseif RunService:IsRunning() then "the game is running"
				else "there was an unknown Roblox issue"

			r.log:warn("Failed to record changes for", displayName, "because", reason, `(recording name: {name})`)
		end

		if not options.ignoreRobloxFailure then
			return function(_operation: Enum.FinishRecordingOperation?) end
		end
	end

	local function finishRecording(operation: Enum.FinishRecordingOperation?)
		if id then
			local recordingId = id
			id = nil
			ChangeHistoryService:FinishRecording(recordingId, operation or Enum.FinishRecordingOperation.Commit)
		end
	end

	r.trove:Add(finishRecording :: any)
	return finishRecording
end

return recordChangeHistory
