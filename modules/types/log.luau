export type LogSelf = {}

export type LogMetatable = {
	__index: LogMetatable,
	__tostring: LogMetatable,

	trace: (self: Log, ...unknown) -> (),
	debug: (self: Log, ...unknown) -> (),
	info: (self: Log, ...unknown) -> (),
	warn: (self: Log, ...unknown) -> (),
	error: (self: Log, ...unknown) -> (),
}

export type Log = setmetatable<LogSelf, LogMetatable>

return nil
