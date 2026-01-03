local fs = require("@lune/fs")
local process = require("@lune/process")

type BuildOutput = "model" | "plugin"
local output = process.args[1] :: BuildOutput
if output ~= "model" and output ~= "plugin" then
	print(`usage: lune run build [model|plugin]`)
	process.exit(1)
end

local INPUT_DIR = "src"
local OUTPUT_DIR = "out"
local EXEC_OPTIONS: process.ExecOptions = { stdio = "forward" }

if fs.isDir(process.cwd .. OUTPUT_DIR) then
	print("Cleaning output directory")
	fs.removeDir(process.cwd .. OUTPUT_DIR)
end

process.exec("rojo", { "sourcemap", "--output", "sourcemap.json" }, EXEC_OPTIONS)
process.exec("darklua", { "process", INPUT_DIR, OUTPUT_DIR }, EXEC_OPTIONS)
process.exec("rojo", { "build", if output == "model" then "--output" else "--plugin", "Rocket.rbxm" }, EXEC_OPTIONS)
process.exit(0)
