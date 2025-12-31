local Iris = require("@pkgs/Iris")
local widgets = Iris.Internal._utility

Iris.Internal.WidgetConstructor(
	"ButtonGroup",
	{
		hasState = false,
		hasChildren = true,
		Args = {
			["Size"] = 1,
		},
		Events = {
			["clicked"] = widgets.EVENTS.click(function(thisWidget: any)
				return thisWidget.Instance
			end),
			["rightClicked"] = widgets.EVENTS.rightClick(function(thisWidget: any)
				return thisWidget.Instance
			end),
			["doubleClicked"] = widgets.EVENTS.doubleClick(function(thisWidget: any)
				return thisWidget.Instance
			end),
			["ctrlClicked"] = widgets.EVENTS.ctrlClick(function(thisWidget: any)
				return thisWidget.Instance
			end),
			["hovered"] = widgets.EVENTS.hover(function(thisWidget: any)
				return thisWidget.Instance
			end),
		},
		Generate = function(_thisWidget: any)
			local ButtonGroup = Instance.new("TextButton")
			ButtonGroup.Name = "Iris_ButtonGroup"
			ButtonGroup.AutomaticSize = Enum.AutomaticSize.XY
			ButtonGroup.Size = UDim2.fromOffset(0, 0)
			ButtonGroup.BackgroundColor3 = Iris._config.ButtonColor
			ButtonGroup.BackgroundTransparency = Iris._config.ButtonTransparency
			ButtonGroup.AutoButtonColor = false
			ButtonGroup.Text = ""

			widgets.UIListLayout(ButtonGroup, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemSpacing.X))

			widgets.applyFrameStyle(ButtonGroup)

			widgets.applyInteractionHighlights("Background", ButtonGroup, ButtonGroup, {
				Color = Iris._config.ButtonColor,
				Transparency = Iris._config.ButtonTransparency,
				HoveredColor = Iris._config.ButtonHoveredColor,
				HoveredTransparency = Iris._config.ButtonHoveredTransparency,
				ActiveColor = Iris._config.ButtonActiveColor,
				ActiveTransparency = Iris._config.ButtonActiveTransparency,
			})

			return ButtonGroup
		end,
		Update = function(thisWidget: any)
			local Button = thisWidget.Instance :: TextButton
			Button.Size = thisWidget.arguments.Size or UDim2.fromOffset(0, 0)
		end,
		ChildAdded = function(thisWidget: any)
			return thisWidget.Instance
		end,
		Discard = function(thisWidget: any)
			thisWidget.Instance:Destroy()
		end,
	} :: any
)

local function ButtonGroup(size: UDim2?): typeof(Iris.Button({})) & typeof(Iris.Group({}))
	return Iris.Internal._Insert("ButtonGroup", { size }) :: any
end

return ButtonGroup
