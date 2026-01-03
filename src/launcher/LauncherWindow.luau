local Iris = require("@src/Iris")
local Theme = require("@theme/Theme")
local launcher = require("@launcher/LauncherStore")
local useViewportSize = require("@utils/useViewportSize")

local WINDOW_ARGS = {
	"Rocket Launcher",
	true, -- NoTitleBar
	false, -- NoBackground
	true, -- NoCollapse
	true, -- NoClose
	true, -- NoMove
	false, -- NoScrollbar
	true, -- NoResize
	true, -- NoNav
	true, -- NoMenu
}

local function LauncherWindow()
	local viewportSize = useViewportSize()
	local windowSize = viewportSize / 2
	Iris.PushConfig({
		WindowPadding = Vector2.zero,
		ContentWidth = UDim.new(1, 0),
	})
	Iris.Window(WINDOW_ARGS, { position = windowSize / 2, size = windowSize } :: any)

	Iris.PushConfig({
		FrameRounding = 0,
		FramePadding = Iris._config.FramePadding * 2,
	})
	local commandToRender, commandContext = launcher.commandToRender, launcher.commandContext
	if commandToRender and commandContext then
		local render, renderNav =
			commandToRender._metadata.renderInLauncher, commandToRender._metadata.renderInLauncherNav

		if renderNav then
			Iris.SameLine()
		end
		local back = Iris.Button("Back")
		if renderNav then
			renderNav(commandContext)
			Iris.End()
		end

		Iris.PopConfig()
		Iris.Separator()

		if render then
			render(commandContext)
		end

		if back.clicked() then
			commandContext.trove:Clean()
		end
	else
		local input = Iris.InputText({ "", "Search commands..." })
		Iris.PopConfig()
		Iris.Separator()

		local inputField = input.Instance:FindFirstChildOfClass("TextBox")
		launcher.search(inputField and inputField.Text or "")
		if not launcher.isFocused() and inputField then
			launcher.isFocused(true)
			inputField:CaptureFocus()
		end

		Iris.ScrollingFrame(UDim2.fromScale(1, 0), Enum.AutomaticSize.None)
		Iris.Flex(Enum.UIFlexMode.Fill)

		-- TODO: proper padding widget
		local paddingInstance = Instance.new("UIPadding")
		local horizontalPadding = UDim.new(0, Iris._config.CellPadding.X)
		local verticalPadding = UDim.new(0, Iris._config.CellPadding.Y)
		paddingInstance.PaddingLeft = horizontalPadding
		paddingInstance.PaddingRight = horizontalPadding
		paddingInstance.PaddingTop = verticalPadding
		paddingInstance.PaddingBottom = verticalPadding
		Iris.Append(paddingInstance :: any)

		local selectedIndex = launcher.selectedIndex()
		for i, cmd in launcher.searchResults() do
			Theme.push(
				if selectedIndex == i then Theme.presets.button.highlighted else Theme.presets.button.unhighlighted
			)

			local button = Iris.ButtonGroup()
			button.Instance.Size = UDim2.fromScale(1, 0)
			button.Instance.LayoutOrder = i

			Iris.Icon(cmd._metadata.icon or cmd._extension._metadata.icon, UDim2.fromOffset(18, 18))
			Iris.Text(cmd._metadata.title)

			Theme.push(Theme.presets.subtext)
			Iris.Text(cmd._extension._metadata.title)
			Iris.PopConfig()

			Iris.End()
			Iris.PopConfig()

			if button.clicked() then
				launcher.runCommand:Fire(cmd)
			end
		end
		Iris.End()
	end

	Iris.End()
	Iris.PopConfig()
end

return LauncherWindow
