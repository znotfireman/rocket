local Charm = require("@pkgs/Charm")
local Command = require("@src/lib/Command")
local Extension = require("@src/lib/Extension")
local Signal = require("@pkgs/Signal")
local fzy = require("@src/vendor/fzy")

local launcher = {}
launcher.isVisible = Charm.atom(false)
launcher.isFocused = Charm.atom(false)
launcher.selectedIndex = Charm.atom(1)
launcher.search = Charm.atom("")

launcher.commandRenderer = nil :: () -> ()?

launcher.searchResults = Charm.computed(function(): { Command.Command }
	local search = launcher.search()
	local allCommands = Extension.allCommands()
	local haystack = table.clone(allCommands)
	if search ~= "" then
		local results = fzy.filter(search, Extension.commandTitles(), false)
		table.sort(results, function(lhs: { number }, rhs: { number })
			return lhs[3] < rhs[3]
		end)
		haystack = table.create(#results) :: { Command.Command }
		for _, result in results do
			table.insert(haystack, allCommands[result[1]])
		end
	end
	return haystack
end)

launcher.runCommand = Signal.new() :: Signal.Signal<Command.Command>

return launcher
