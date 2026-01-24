local cli = require("@batteries/cli")
local process = require("@lute/process")
local stringext = require("@std/stringext")

local Summon = {}
Summon.__index = Summon

export type Summon = setmetatable<{
	program: string,
	arguments: { string },
	cwd: string,
	env: { [string]: string },
	stdio: process.StdioKind,
}, typeof(Summon)>

function Summon.withArg(self: Summon, arg: string?)
	if arg then
		table.insert(self.arguments, arg)
	end
	return self
end

function Summon.withCliFlag(self: Summon, args: cli.Parser, flag: string)
	if args:has(flag) then
		table.insert(self.arguments, `--{flag}`)
	end
	return self
end

function Summon.withCliOption(self: Summon, args: cli.Parser, option: string)
	local value = args:get(option)
	if value then
		table.insert(self.arguments, `--{option}={value}`)
	end
	return self
end

function Summon.withCwd(self: Summon, cwd: string)
	self.cwd = cwd
	return self
end

function Summon.withEnv(self: Summon, key: string, value: string?)
	self.env[key] = value
	return self
end

function Summon.withStdio(self: Summon, stdio: process.StdioKind)
	self.stdio = stdio
	return self
end

function Summon.getCommand(self: Summon)
	return `{self.program} {table.concat(self.arguments, " ")}`
end

function Summon.printErr(self: Summon, result: process.ProcessResult)
	print(stringext.trim(result.stdout .. result.stderr))
	print(`Command {self.program} failed with code {result.exitcode}`)
end

function Summon.run(self: Summon)
	local command = self:getCommand()
	print(`> {command}`)
	return process.system(command, {
		cwd = self.cwd,
		env = self.env,
		stdio = self.stdio,
	})
end

function Summon.assert(self: Summon)
	local result = self:run()
	if result.ok then
		return result
	end
	self:printErr(result)
	return process.exit(1)
end

function Summon.new(program: string, ...: string): Summon
	return setmetatable({
		program = program,
		arguments = { ... },
		cwd = process.cwd(),
		env = {},
		stdio = "inherit",
	}, Summon)
end

function Summon.codeFromMany(...: Summon)
	local code = 0

	for i = 1, select("#", ...) do
		local summon: Summon = select(i, ...)
		local result = summon:run()
		if not result.ok then
			summon:printErr(result)
			code = 1
		end
	end

	return code
end

function Summon.exitFromMany(...: Summon)
	return process.exit((Summon.codeFromMany :: any)(...))
end

return table.freeze(Summon)
