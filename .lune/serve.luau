local process = require("@lune/process")
local task = require("@lune/task")
local fs = require("@lune/fs")

pcall(fs.removeDir, "out")

task.spawn(
	process.exec,
	"rojo",
	{ "sourcemap", "--watch", "--output", "sourcemap.json" },
	{ stdio = "inherit" } :: process.ExecOptions?
)

task.spawn(
	process.exec,
	"darklua",
	{ "process", "--watch", "src", "out" },
	{ stdio = "inherit" } :: process.ExecOptions?
)

task.spawn(
	process.exec,
	"rojo",
	{ "build", "--watch", "--plugin", "rocket.rbxm", "build.project.json" },
	{ stdio = "inherit" } :: process.ExecOptions?
)
