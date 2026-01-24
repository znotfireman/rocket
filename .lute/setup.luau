local Summon = require("@lib/utils/Summon")
local process = require("@lute/process")

process.exit(Summon.codeFromMany(Summon.new("lute", "setup-lute-typedefs")))
