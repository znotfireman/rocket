-- https://discord.com/channels/385151591524597761/1097898141396766771/1455680322279571516

local Iris = require("@pkgs/Iris")
local Internal = Iris.Internal
local widgets = Internal._utility

Internal.WidgetConstructor(
	"Frame",
	{
		hasState = false,
		hasChildren = true,
		Args = {
			["Size"] = 1,
			["AutomaticSize"] = 2,
			["VerticalAlignment"] = 3,
			["HorizontalAlignment"] = 4,
		},
		Events = {},
		Generate = function(thisWidget: any)
			local Frame: Frame = Instance.new("Frame")
			Frame.Name = "Iris_Frame"
			Frame.AutomaticSize = Enum.AutomaticSize.XY
			Frame.Size = UDim2.fromOffset(0, 0)
			Frame.BackgroundTransparency = 1
			Frame.BorderSizePixel = 0
			Frame.LayoutOrder = thisWidget.ZIndex
			Frame.ClipsDescendants = true

			widgets.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

			return Frame
		end,
		Update = function(thisWidget: any)
			local Frame = thisWidget.Instance :: any
			local uiListLayout: any = Frame.UIListLayout

			if thisWidget.arguments.VerticalAlignment then
				uiListLayout.VerticalAlignment = thisWidget.arguments.VerticalAlignment
			else
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			end

			if thisWidget.arguments.HorizontalAlignment then
				uiListLayout.HorizontalAlignment = thisWidget.arguments.HorizontalAlignment
			else
				uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			end

			Frame.Size = thisWidget.arguments.Size or UDim2.fromOffset(0, 0)
			Frame.AutomaticSize = thisWidget.arguments.AutomaticSize or Enum.AutomaticSize.XY
		end,
		Discard = function(thisWidget: any)
			thisWidget.Instance:Destroy()
		end,
		ChildAdded = function(thisWidget: any, _thisChild: any)
			return thisWidget.Instance
		end,
	} :: any
)

local function Frame(
	size: UDim2?,
	automaticSize: Enum.AutomaticSize?,
	verticalAlignment: Enum.VerticalAlignment?,
	horizontalAlignment: Enum.HorizontalAlignment?
)
	return Internal._Insert("Frame", { size, automaticSize, verticalAlignment, horizontalAlignment })
end

return Frame
