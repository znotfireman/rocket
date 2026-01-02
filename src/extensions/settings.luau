local Extension = require("@src/Extension")
local SettingsPages = require("@settings/SettingsPages")
local SettingsStore = require("@settings/SettingsStore")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-settings",
	title = "Rocket Settings",
	description = "Manage your Rocket Settings",
	icon = { Image = assets.extensions.settings.base },
	authors = { "Team Fireworks" },
})

for _, page in SettingsPages do
	ext:newCommand({
		id = `page-{page.id}`,
		title = page.title,
		description = `Open the {page.title} panel in Rocket Settings.`,
		icon = { Image = page.extensionIcon },
		run = function()
			SettingsStore.currentPage(page)
			SettingsStore.isVisible(true)
		end,
	})
end

return ext
