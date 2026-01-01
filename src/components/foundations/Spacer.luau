local Iris = require("@pkgs/Iris")

Iris.Internal.WidgetConstructor(
	"Spacer",
	{
		hasState = false,
		hasChildren = false,
		Args = {
			["FlexMode"] = 1,
		},
		Events = {},
		Generate = function(_thisWidget: any)
			local Spacer = Instance.new("Frame")
			Spacer.Name = "Iris_Spacer"
			Spacer.AutomaticSize = Enum.AutomaticSize.XY
			Spacer.Size = UDim2.fromOffset(0, 0)
			Spacer.BackgroundTransparency = 1

			Instance.new("UIFlexItem").Parent = Spacer

			return Spacer
		end,
		Update = function(thisWidget: any)
			local flex: UIFlexItem = thisWidget.Instance:FindFirstChildOfClass("UIFlexItem")
			if flex then
				flex.FlexMode = thisWidget.arguments.FlexMode or Enum.UIFlexMode.None
			end
		end,
		Discard = function(thisWidget: any)
			thisWidget.Instance:Destroy()
		end,
	} :: any
)

local function Spacer(mode: Enum.UIFlexMode?)
	return Iris.Internal._Insert("Spacer", { mode })
end

return Spacer
