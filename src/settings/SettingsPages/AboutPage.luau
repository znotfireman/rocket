local Iris = require("@iris/Iris")
local assets = require("@src/assets")
local types = require("@settings/types")

local manifest = require(script:FindFirstAncestor("Rocket").include:WaitForChild("pesde.toml"))

local AboutPage = {} :: types.SettingsPage
AboutPage.id = "about"
AboutPage.title = "About"
AboutPage.tabIcon = assets.icons.rocket
AboutPage.extensionIcon = assets.extensions.settings.about

function AboutPage.render()
	Iris.Frame(UDim2.fromScale(1, 0), Enum.AutomaticSize.Y, Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Center)
	Iris.Image(assets.brand.rocket, UDim2.fromOffset(128, 128))
	Iris.Header(`Rocket v{manifest.version}`)
	Iris.PushConfig({ ImageColor = Iris._config.TextColor })

	Iris.SameLine(nil, Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Center)
	Iris.Image(assets.brand.github, UDim2.fromOffset(24, 24))
	Iris.Text("team-fireworks/rocket")
	Iris.End()

	Iris.Spacer(12)

	Iris.PushConfig({ ImageTransparency = 0.5 })
	-- selene: allow(incorrect_standard_library_use)
	Iris.Image(assets.brand.teamfireworks, UDim2.new(1, 0, 0, 32), Rect.new(), Enum.ScaleType.Fit)
	Iris.PopConfig()

	Iris.PopConfig()
	Iris.End()
end

return AboutPage
