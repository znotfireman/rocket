if not plugin then
	error("Rocket must be run as a plugin!")
end

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Charm = require("@pkgs/Charm")
local Command = require("@src/lib/Command")
local Extension = require("@src/lib/Extension")
local Iris = require("@pkgs/Iris")
local Trove = require("@pkgs/Trove")
local launcher = require("@src/atoms/launcher")
local renderLauncher = require("@src/components/renderLauncher")

local pluginTrove = Trove.new()
pluginTrove:Add(plugin.Unloading:Connect(pluginTrove:WrapClean()))

local function toggleIsPaletteVisibile()
	launcher.isVisible(not launcher.isVisible())
end

local function start()
	for _, module in script.Parent:WaitForChild("extensions"):GetDescendants() do
		if module:IsA("ModuleScript") then
			local requireSuccess, requireError = pcall(require, module)
			if not requireSuccess then
				warn("Failed to require extension module", module:GetFullName(), "because:", requireError)
				continue
			end
		end
	end

	local launchAction = (
		plugin:CreatePluginAction("@rocket/launch", "Launch Rocket", "Launches the Rocket command palette", "", false)
	)

	local toolbar = plugin:CreateToolbar("Rocket")
	local launchButton = toolbar:CreateButton("@rocket/launch", "Launches the Rocket command palette", "", "Launch")
	local _settingsButton = toolbar:CreateButton("@rocket/settings", "Configure Rocket", "", "Settings")

	launchAction.Triggered:Connect(toggleIsPaletteVisibile)
	launchButton.Click:Connect(toggleIsPaletteVisibile)

	local paletteInputTrove = pluginTrove:Extend()
	pluginTrove:Add(Charm.subscribe(launcher.isVisible, function(isVisible)
		launcher.search("")
		launcher.selectedIndex(0)
		launchButton:SetActive(isVisible)
		paletteInputTrove:Clean()

		if isVisible then
			paletteInputTrove:Add(UserInputService.InputBegan:Connect(function(input)
				local keycode = input.KeyCode

				if keycode == Enum.KeyCode.Up then
					launcher.selectedIndex(math.max(launcher.selectedIndex() - 1, 1))
				elseif keycode == Enum.KeyCode.Down then
					launcher.selectedIndex(math.min(launcher.selectedIndex() + 1, #launcher.searchResults()))
				elseif keycode == Enum.KeyCode.Return then
					launcher.runCommand:Fire(Extension.allCommands()[launcher.selectedIndex()])
				elseif keycode == Enum.KeyCode.Escape then
					launcher.isVisible(false)
				end
			end))
		end
	end) :: any)

	local viewportRenderers: { [Command.Command]: Command.CommandContext } = {}
	pluginTrove:Add(launcher.runCommand:Connect(function(cmd: Command.Command)
		local cmdTrove = pluginTrove:Extend()
		local ctx: Command.CommandContext = {
			trove = cmdTrove,
			iris = Iris,
		}

		local run = cmd._metadata.run
		local renderInLauncher = cmd._metadata.renderInLauncher
		local renderInViewport = cmd._metadata.renderInViewport

		if run then
			pcall(run, ctx)
		end

		if not renderInLauncher and not renderInViewport then
			cmdTrove:Clean()
		else
			if renderInLauncher then
				local function render()
					renderInLauncher(ctx)
				end
				launcher.commandRenderer = render
				cmdTrove:Add(function()
					if launcher.commandRenderer == render then
						launcher.commandRenderer = nil
					end
				end)
				return
			end
			if renderInViewport then
				viewportRenderers[cmd] = ctx
				cmdTrove:Add(function()
					viewportRenderers[cmd] = nil
				end)
			end
		end

		launcher.isVisible(false)
	end))

	local ui = pluginTrove:Add(Instance.new("ScreenGui"))
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

		for _, cmd in Extension.allCommands() do
			local ctx = viewportRenderers[cmd]
			if ctx then
				(cmd._metadata.renderInViewport :: any)(ctx)
			end
		end
	end)

	pluginTrove:Add(Iris.Shutdown :: any)
end

local startSuccess, startError = pcall(start :: any)
if not startSuccess then
	warn("Failed to start Rocket:", startError)
	pluginTrove:Clean()
end
