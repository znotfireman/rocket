if not plugin then
	error("Rocket must be run as a plugin!")
end

local CoreGui = game:GetService("CoreGui")
local Selection = game:GetService("Selection")
local UserInputService = game:GetService("UserInputService")

local Charm = require("@pkgs/Charm")
local Command = require("@src/Command")
local CommandContext = require("@src/CommandContext")
local Extension = require("@src/Extension")
local Gizmos = require("./Gizmos")
local Iris = require("@src/Iris")
local LauncherStore = require("@launcher/LauncherStore")
local LauncherWindow = require("@launcher/LauncherWindow")
local SettingsPages = require("@settings/SettingsPages")
local SettingsStore = require("@settings/SettingsStore")
local SettingsWindow = require("@settings/SettingsWindow")
local Theme = require("@theme/Theme")
local Trove = require("@pkgs/Trove")
local assets = require("@src/assets")

local pluginTrove = Trove.new()
pluginTrove:Add(plugin.Unloading:Connect(pluginTrove:WrapClean()))

local function createPluginAction(id: string, title: string, tooltip: string, icon: string)
	id = "rocket/" .. id
	local action = plugin:CreatePluginAction(id, title, tooltip, icon, true)
	action.Name = id
	return action
end

local function toggleIsLauncherVisible()
	LauncherStore.isVisible(not LauncherStore.isVisible())
end

local function toggleIsSettingsVisible()
	SettingsStore.currentPage(SettingsPages[1])
	SettingsStore.isVisible(not SettingsStore.isVisible())
end

local function start()
	for _, module in script.Parent:WaitForChild("extensions"):GetDescendants() do
		if module:IsA("ModuleScript") then
			local requireSuccess = pcall(require, module)
			if not requireSuccess then
				-- warn("Failed to require extension module", module:GetFullName(), "because:", requireError)
				continue
			end
		end
	end

	local toolbar = plugin:CreateToolbar("Rocket")
	local launchButton = (
		toolbar:CreateButton("@rocket/launch", "Launches the Rocket command palette", assets.brand.rocket, "Launch")
	)

	local settingsButton = (
		toolbar:CreateButton("@rocket/settings", "Configure Rocket", assets.brand.settings, "Settings")
	)

	local launchAction = (
		createPluginAction("launch", "Launch Rocket", "Launches the Rocket command palette", assets.brand.rocket)
	)

	launchButton.Click:Connect(toggleIsLauncherVisible)
	settingsButton.Click:Connect(toggleIsSettingsVisible)
	launchAction.Triggered:Connect(toggleIsLauncherVisible)

	Charm.subscribe(SettingsStore.isVisible, function(isVisible)
		settingsButton:SetActive(isVisible)
	end)

	local launcherInputTrove = pluginTrove:Extend()
	pluginTrove:Add(Charm.subscribe(LauncherStore.isVisible, function(isVisible: boolean)
		LauncherStore.isFocused(false)
		LauncherStore.search("")
		LauncherStore.selectedIndex(1)
		launchButton:SetActive(isVisible)

		launcherInputTrove:Clean()

		if isVisible then
			launcherInputTrove:Add(UserInputService.InputBegan:Connect(function(input)
				local keycode = input.KeyCode

				if keycode == Enum.KeyCode.Up then
					LauncherStore.selectedIndex(math.max(LauncherStore.selectedIndex() - 1, 1))
				elseif keycode == Enum.KeyCode.Down then
					LauncherStore.selectedIndex(
						math.min(LauncherStore.selectedIndex() + 1, #LauncherStore.searchResults())
					)
				elseif keycode == Enum.KeyCode.Return then
					local command = LauncherStore.searchResults()[LauncherStore.selectedIndex()]
					if command then
						LauncherStore.runCommand:Fire(command)
					end
				elseif keycode == Enum.KeyCode.Escape then
					local commandContext = LauncherStore.commandContext
					if commandContext then
						commandContext.trove:Clean()
					else
						LauncherStore.isVisible(false)
					end
				end
			end))
		end
	end) :: any)

	local commandActions: { [Command.Command]: PluginAction } = {}
	local function createCommandPluginActions(newCommands: { Command.Command })
		for _, cmd in newCommands do
			if not commandActions[cmd] then
				local action = createPluginAction(
					`command/{cmd:formatId()}`,
					cmd._metadata.title,
					cmd._metadata.description,
					cmd._metadata.icon and cmd._metadata.icon.Image
						or cmd._extension._metadata.icon.Image
						or assets.brand.rocket
				)

				action.Triggered:Connect(function()
					LauncherStore.runCommand:Fire(cmd)
				end)

				commandActions[cmd] = action
			end
		end
	end

	Charm.subscribe(Extension.allCommands, createCommandPluginActions)
	task.spawn(createCommandPluginActions, Extension.allCommands())

	local viewportCommands: { [Command.Command]: CommandContext.CommandContext } = {}
	pluginTrove:Add(LauncherStore.runCommand:Connect(function(cmd: Command.Command)
		local cmdTrove = pluginTrove:Extend()
		local ctx = CommandContext.new(cmd, plugin, cmdTrove)

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
				LauncherStore.commandToRender = cmd
				LauncherStore.commandContext = ctx
				cmdTrove:Add(function()
					if LauncherStore.commandToRender == cmd then
						LauncherStore.commandToRender = nil
					end
					if LauncherStore.commandContext == ctx then
						LauncherStore.commandContext = nil
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

		LauncherStore.isVisible(false)
	end))

	local ui = pluginTrove:Add(Instance.new("ScreenGui"))
	ui.Name = "Rocket"
	ui.DisplayOrder = 1000
	ui.Parent = CoreGui

	Iris.Init(ui :: any)
	Iris.UpdateGlobalConfig(Theme.config() :: any)
	pluginTrove:Add((Charm.subscribe :: any)(Theme.config, Iris.UpdateGlobalConfig))
	Iris.Connect(getmetatable(Iris).__index, function()
		if LauncherStore.isVisible() then
			LauncherWindow()
		end

		if SettingsStore.isVisible() then
			SettingsWindow()
		end

		for _, cmd in Extension.allCommands() do
			local ctx = viewportCommands[cmd]
			if ctx then
				(cmd._metadata.renderInViewport :: any)(ctx)
			end
		end

		Gizmos.step()
	end)

	pluginTrove:Add(Iris.Shutdown :: any)
	pluginTrove:Add(Gizmos.destroyPool)
	pluginTrove:Add(Gizmos.getFolder())
end

local startSuccess, startError = pcall(start :: any)
if not startSuccess then
	warn("Failed to start Rocket:", startError)
	pluginTrove:Clean()
end
