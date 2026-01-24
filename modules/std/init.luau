local identity = require("@modules/std/functions/identity")
local noop = require("@modules/std/functions/noop")
local recordChangeHistory = require("@modules/std/history/recordChangeHistory")

export type RecordChangeHistoryOptions = recordChangeHistory.RecordChangeHistoryOptions

local std = table.freeze({
	recordChangeHistory = recordChangeHistory,

	identity = identity,
	noop = noop,
	singleton = identity :: <T>(singleton: T | "") -> T,
})

return std
