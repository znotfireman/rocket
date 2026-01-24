local cli = require("@batteries/cli")
local process = require("@lute/process")
local useModules = require("@monorepo/useModules")
local useRepository = require("@monorepo/useRepository")

local args = cli.parser()
args:add("repoconfig", "option", { help = "Path from the CWD to repository config" })
args:add("help", "flag", { help = "Shows help" })

args:parse({ ... })

if args:has("help") then
	print("Sanity checks Rocket's config files")
	args:help()
	process.exit(0)
	return
else
	useModules(useRepository(args:get("repoconfig")))
	print("All modules are valid")
end

process.exit(0)
