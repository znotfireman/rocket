local Iris = require("@pkgs/Iris")
local Internal = Iris.Internal

Internal.WidgetConstructor(
	"FlexSpacer",
	{
		hasState = false,
		hasChildren = false,
		Args = {
			["FlexMode"] = 1,
		},
		Events = {},
		Generate = function(_thisWidget: any)
			local FlexSpacer = Instance.new("Frame")
			FlexSpacer.Name = "Iris_FlexSpacer"
			FlexSpacer.AutomaticSize = Enum.AutomaticSize.XY
			FlexSpacer.Size = UDim2.fromOffset(0, 0)
			FlexSpacer.BackgroundTransparency = 1

			Instance.new("UIFlexItem").Parent = FlexSpacer

			return FlexSpacer
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

local function FlexSpacer(mode: Enum.UIFlexMode?)
	return Internal._Insert("FlexSpacer", { mode })
end

return FlexSpacer
