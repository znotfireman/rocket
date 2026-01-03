local Iris = require("@pkgs/Iris")
local types = require("@src/types")

local function Icon(props: types.Icon, size: UDim2)
	Iris.PushConfig({
		ImageColor = props.ImageColor or Color3.new(1, 1, 1),
		ImageTransparency = props.ImageTransparency or 0,
	})

	local icon = Iris.Image({
		props.Image,
		size,
		props.Rect,
		props.ScaleType,
		props.ResamplerMode,
		props.TileSize,
		props.SliceCenter,
		props.SliceScale,
	})

	Iris.PopConfig()

	local image = icon.Instance :: ImageLabel
	if props.BackgroundColor then
		image.BackgroundTransparency = 0
		image.BackgroundColor3 = props.BackgroundColor
	end
	if props.ImageRectOffset then
		image.ImageRectOffset = props.ImageRectOffset
	end
	if props.ImageRectSize then
		image.ImageRectSize = props.ImageRectSize
	end

	return icon
end

return Icon
