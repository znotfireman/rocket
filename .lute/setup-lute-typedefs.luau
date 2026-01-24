-- This script copies Lute's type definitions to the repository's
-- `.lute/typedefs` directory for the LSP.

local Summon = require("@lib/utils/Summon")
local copyInto = require("@lib/utils/copyInto")
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")

local LUTE_VERSION = "0.1.0"
local SRC_BASE_PATH = path.parse(`.lute/typedefs/{LUTE_VERSION}`)
local SRC_PATH = path.join(process.homedir(), SRC_BASE_PATH)
local DESTINATION_PATH = path.join(process.cwd(), ".lute", "typedefs")

if fs.exists(DESTINATION_PATH) then
	for _, entry in fs.listdirectory(DESTINATION_PATH) do
		if entry.type == "dir" then
			fs.removedirectory(path.join(DESTINATION_PATH, entry.name), { recursive = true })
		end
	end
else
	Summon.new("lute", "setup"):assert()
end

copyInto(SRC_PATH, DESTINATION_PATH)
