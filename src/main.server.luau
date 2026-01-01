if not plugin then
	error("Rocket must be run as a plugin!")
end

local CoreGui = game:GetService("CoreGui")
local Selection = game:GetService("Selection")
local UserInputService = game:GetService("UserInputService")

local Charm = require("@pkgs/Charm")
local Command = require("@src/lib/Command")
local Extension = require("@src/lib/Extension")
local Iris = require("@pkgs/Iris")
local Trove = require("@pkgs/Trove")
local assets = require("./assets")
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

	print(table.concat(Extension.commandTitles(), ", "))

	local launchAction = (
		plugin:CreatePluginAction("@rocket/launch", "Launch Rocket", "Launches the Rocket command palette", "", false)
	)

	local toolbar = plugin:CreateToolbar("Rocket")
	local launchButton = (
		toolbar:CreateButton("@rocket/launch", "Launches the Rocket command palette", assets.brand.rocket, "Launch")
	)

	local _settingsButton = (
		toolbar:CreateButton("@rocket/settings", "Configure Rocket", assets.brand.settings, "Settings")
	)

	launchAction.Triggered:Connect(toggleIsPaletteVisibile)
	launchButton.Click:Connect(toggleIsPaletteVisibile)

	local launcherInputTrove = pluginTrove:Extend()
	pluginTrove:Add(Charm.subscribe(launcher.isVisible, function(isVisible)
		launcher.search("")
		launcher.selectedIndex(0)
		launchButton:SetActive(isVisible)
		launcherInputTrove:Clean()

		if isVisible then
			launcherInputTrove:Add(UserInputService.InputBegan:Connect(function(input)
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

	local viewportCommands: { [Command.Command]: Command.CommandContext } = {}
	pluginTrove:Add(launcher.runCommand:Connect(function(cmd: Command.Command)
		local cmdTrove = pluginTrove:Extend()
		local ctx: Command.CommandContext = {
			trove = cmdTrove,
			iris = Iris,
		}

		local run = cmd._metadata.run
		local runSelected = cmd._metadata.runSelected
		local renderInLauncher = cmd._metadata.renderInLauncher
		local renderInViewport = cmd._metadata.renderInViewport

		if run then
			pcall(run, ctx)
		end

		if runSelected then
			for _, instance in Selection:Get() do
				pcall(runSelected, ctx, instance)
			end
		end

		if not renderInLauncher and not renderInViewport then
			cmdTrove:Clean()
		else
			if renderInLauncher then
				launcher.commandToRender = cmd
				launcher.commandContext = ctx
				cmdTrove:Add(function()
					if launcher.commandToRender == cmd then
						launcher.commandToRender = nil
					end
					if launcher.commandContext == ctx then
						launcher.commandContext = nil
					end
				end)
				launcherInputTrove:Add(cmdTrove)
				return
			end
			if renderInViewport then
				viewportCommands[cmd] = ctx
				cmdTrove:Add(function()
					viewportCommands[cmd] = nil
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
	Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear :: any)
	Iris.UpdateGlobalConfig({
		RichText = true,
		FrameBorderSize = 0,
		IgnoreGuiInset = true,
		TextFont = Font.fromEnum(Enum.Font.SourceSans),
	})
	Iris:Connect(function()
		if launcher.isVisible() then
			renderLauncher()
		end

		for _, cmd in Extension.allCommands() do
			local ctx = viewportCommands[cmd]
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
