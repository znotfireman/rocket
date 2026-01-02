local Charm = require("@pkgs/Charm")
local Iris = require("@pkgs/Iris")
local Trove = require("@pkgs/Trove")
local types = require("@theme/types")

export type Config = types.Config
export type PartialConfig = types.PartialConfig
export type Theme = types.Theme
export type StudioTheme = types.StudioTheme

local theme = {}
theme.themes = table.freeze({
	iris = require("@theme/themes/iris"),
})

theme.presets = table.freeze({
	base = require("@theme/presets/base"),
	subtext = require("@theme/presets/subtext"),
	header = require("@theme/presets/header"),
	button = table.freeze({
		highlighted = require("@theme/presets/button/highlighted"),
		unhighlighted = require("@theme/presets/button/unhighlighted"),
		selected = require("@theme/presets/button/selected"),
	}),
})

function theme.push(config: PartialConfig)
	Iris.PushConfig(config :: any)
end

function theme.pop()
	Iris.PopConfig()
end

function theme.apply<T, Args...>(config: PartialConfig, ctor: (Args...) -> T, ...: Args...): T
	theme.push(config)
	local result = ctor(...)
	theme.pop()
	return result
end

function theme.getStudio(): "dark" | "light"
	local studioBG = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	local isDark = studioBG.R + studioBG.G + studioBG.B < 1.5
	return if isDark then "dark" else "light"
end

theme.studio = Charm.atom(theme.getStudio())
function theme.observeStudio(trove: Trove.Trove)
	trove:Add(settings().Studio.ThemeChanged:Connect(function()
		theme.studio(theme.getStudio())
	end))
end

theme.userPreferredTheme = Charm.atom(theme.themes.iris) :: Charm.Atom<Theme | StudioTheme>

theme.selectedUserTheme = Charm.computed(function(): Theme
	local userPreferredTheme = theme.userPreferredTheme()
	local asTheme, asStudio = userPreferredTheme :: Theme, userPreferredTheme :: StudioTheme
	return if asTheme.name then asTheme else (asStudio :: any)[theme.studio()]
end)

theme.config = Charm.computed(function(): PartialConfig
	local config = table.clone(theme.presets.base)
	for key, value in theme.selectedUserTheme() :: { [string]: any } do
		(config :: any)[key] = value
	end
	return config
end)

return table.freeze(theme)
