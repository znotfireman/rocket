local Workspace = game:GetService("Workspace")

local ButtonGroup = require("./ButtonGroup")
local Iris = require("@pkgs/Iris")
local launcher = require("@src/atoms/launcher")

local COMMAND_HIGHLIGHTED_CONFIG = {
	ButtonTransparency = 0.5,
	ButtonHoveredTransparency = 0.5,
	ButtonActiveTransparency = 0.25,
}

local COMMAND_DEFAULT_CONFIG = {
	ButtonTransparency = 1,
	ButtonHoveredTransparency = 0.5,
	ButtonActiveTransparency = 0.25,
}

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

local function useViewportSize(): Vector2
	local camera = Workspace:FindFirstChildOfClass("Camera")
	if camera then
		return camera.ViewportSize
	end
	return Vector2.zero
end

local function renderLauncher()
	local viewportSize = useViewportSize()
	local windowSize = viewportSize / 2
	Iris.PushConfig({ WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero, ContentWidth = UDim.new(1, 0) })
	Iris.Window(WINDOW_ARGS, { position = windowSize / 2, size = windowSize } :: any)

	Iris.PushConfig({ FrameRounding = 0 })
	local input = Iris.InputText({ "", "Search for apps and commands..." })
	Iris.PopConfig()

	local inputField = input.Instance:FindFirstChildOfClass("TextBox")
	launcher.search(inputField and inputField.Text or "")
	if not launcher.isFocused() and inputField then
		launcher.isFocused(true)
		-- this bricks your mouse??? how???
		-- inputField:CaptureFocus()
	end

	if launcher.commandRenderer then
		launcher.commandRenderer()
	else
		local extensionContainer = Iris.Table({ 1 })
		-- HACK: iris has no proper layouting widgets
		local extensionContainerSize = windowSize - Vector2.new(0, 24 * 2)
		extensionContainer.Instance.Size = UDim2.fromOffset(extensionContainerSize.X, extensionContainerSize.Y)
		local selectedIndex = launcher.selectedIndex()
		for i, cmd in launcher.searchResults() do
			Iris.PushConfig(if selectedIndex == i then COMMAND_HIGHLIGHTED_CONFIG else COMMAND_DEFAULT_CONFIG)

			local button = ButtonGroup()
			button.Instance.Size = UDim2.new(1, 0, 0, button.Instance.Size.Height.Offset)
			button.Instance.LayoutOrder = i

			Iris.Text({ cmd._metadata.title })

			Iris.PushConfig({ TextTransparency = 0.5 })
			Iris.Text({ cmd._extension._metadata.title })
			Iris.PopConfig()

			Iris.End()

			if button.clicked() then
				launcher.runCommand:Fire(cmd)
			end

			Iris.PopConfig()
		end
		Iris.End()
	end

	Iris.End()
	Iris.PopConfig()
end

return renderLauncher
