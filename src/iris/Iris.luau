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

	ButtonGroup = require("@iris/widgets/ButtonGroup"),
	Icon = require("@iris/widgets/Icon"),
	Header = require("@iris/widgets/Header"),
	Subtext = require("@iris/widgets/Subtext"),
	Frame = require("@iris/widgets/Frame"),
	ScrollingFrame = require("@iris/widgets/ScrollingFrame"),
	Flex = require("@iris/widgets/Flex"),
	FlexSpacer = require("@iris/widgets/FlexSpacer"),
	Spacer = require("@iris/widgets/Spacer"),

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
