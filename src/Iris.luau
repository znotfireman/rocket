local Iris = require("@pkgs/Iris")
local typeforge = require("@vendor/typeforge")

local function tupleify<Returns>(ctor: (...any) -> Returns): (...any) -> Returns
	return function(...)
		return ctor(select("#", ...) > 0 and { ... } or nil)
	end
end

local ext = {
	self = Iris,

	PushConfig = Iris.PushConfig :: (deltaStyles: typeforge.Partial<typeof(Iris._config)>) -> (),

	ButtonGroup = require("@src/widgets/ButtonGroup"),
	Icon = require("@src/widgets/Icon"),
	Header = require("@src/widgets/Header"),
	Subtext = require("@src/widgets/Subtext"),
	Frame = require("@src/widgets/Frame"),
	ScrollingFrame = require("@src/widgets/ScrollingFrame"),
	Flex = require("@src/widgets/Flex"),
	FlexSpacer = require("@src/widgets/FlexSpacer"),
	Spacer = require("@src/widgets/Spacer"),

	-- patching stateless constructors to use tuple syntax for DX
	Tooltip = tupleify(Iris.Tooltip) :: (text: string) -> typeof(Iris.Tooltip(...)),
	Indent = tupleify(Iris.Indent) :: (width: number?) -> typeof(Iris.Indent(...)),
	SameLine = tupleify(Iris.SameLine) :: (
		width: number?,
		verticalAlignment: Enum.VerticalAlignment?,
		horizontal: Enum.HorizontalAlignment?
	) -> typeof(Iris.SameLine(...)),
	MenuItem = tupleify(Iris.MenuItem) :: (text: string, keyCode: Enum.KeyCode?, modifierKey: Enum.ModifierKey?) -> typeof(Iris.MenuItem(...)),
	Text = tupleify(Iris.Text) :: (text: string, color: Color3?) -> typeof(Iris.Text(...)),
	SeparatorText = tupleify(Iris.SeparatorText) :: (text: string) -> typeof(Iris.SeparatorText(...)),
	Button = tupleify(Iris.Button) :: (text: string, size: UDim2?) -> typeof(Iris.Button(...)),
	SmallButton = tupleify(Iris.Button) :: (text: string, size: UDim2?) -> typeof(Iris.Button(...)),
	Image = tupleify(Iris.Image) :: (
		image: string,
		size: UDim2,
		rect: Rect?,
		scaleType: Enum.ScaleType?,
		resamplerMode: Enum.ResamplerMode?,
		tileSize: UDim2?,
		sliceCenter: Rect?,
		sliceScale: number?
	) -> typeof(Iris.Image(...)),
	ImageButton = tupleify(Iris.Image) :: (
		image: string,
		size: UDim2,
		rect: Rect?,
		scaleType: Enum.ScaleType?,
		resamplerMode: Enum.ResamplerMode?,
		tileSize: UDim2?,
		sliceCenter: Rect?,
		sliceScale: number?
	) -> typeof(Iris.ImageButton(...)),
}

setmetatable(ext, { __index = Iris })
return ext
