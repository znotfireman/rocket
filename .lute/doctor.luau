local Summon = require("@lib/utils/Summon")
local process = require("@lute/process")

print("Doctoring Rocket...")
process.exit(Summon.codeFromMany(Summon.new("lute", "validate-configs")))
