if not plugin then
	error("Rocket must be run as a plugin!")
end

local CoreGui = game:GetService("CoreGui")

local Charm = require("@pkgs/Charm")
local Extension = require("@src/lib/Extension")
local Iris = require("@pkgs/Iris")
local Trove = require("@pkgs/Trove")
local launcher = require("@src/atoms/launcher")
local renderLauncher = require("@src/components/renderLauncher")

local pluginTrove = Trove.new()
pluginTrove:Add(plugin.Unloading:Connect(pluginTrove:WrapClean()))

local function requireExtensionModules()
	for _, module in script.Parent:WaitForChild("extensions"):GetDescendants() do
		if module:IsA("ModuleScript") then
			local requireSuccess, requireError = pcall(require, module)
			if not requireSuccess then
				warn("Failed to require extension module", module:GetFullName(), "because:", requireError)
				continue
			end
		end
	end
end

local function mountUi()
	local ui = Instance.new("ScreenGui")
	ui.Name = "Rocket"
	ui.DisplayOrder = 1000
	ui.Parent = CoreGui

	Iris.Init(ui :: any)
	Iris.UpdateGlobalConfig({ RichText = true, FrameBorderSize = 0 })
	Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear :: any)
	Iris:Connect(function()
		if launcher.isVisible() then
			renderLauncher()
		end
	end)

	pluginTrove:Add(Iris.Shutdown :: any)
end

local function toggleIsPaletteVisibile()
	launcher.isVisible(not launcher.isVisible())
end

local function start()
	requireExtensionModules()

	local launchAction = (
		plugin:CreatePluginAction("@rocket/launch", "Launch Rocket", "Launches the Rocket command palette", "", false)
	)

	local toolbar = plugin:CreateToolbar("Rocket")
	local launchButton = toolbar:CreateButton("@rocket/launch", "Launches the Rocket command palette", "", "Launch")
	local _settingsButton = toolbar:CreateButton("@rocket/settings", "Configure Rocket", "", "Settings")

	launchAction.Triggered:Connect(toggleIsPaletteVisibile)
	launchButton.Click:Connect(toggleIsPaletteVisibile)

	pluginTrove:Add(Charm.subscribe(launcher.isVisible, function(isVisible)
		launchButton:SetActive(isVisible)
	end) :: any)

	mountUi()
end

local startSuccess, startError = pcall(start :: any)
if not startSuccess then
	warn("Failed to start Rocket:", startError)
	pluginTrove:Clean()
end
