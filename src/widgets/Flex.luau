local Iris = require("@pkgs/Iris")
local Internal = Iris.Internal

Internal.WidgetConstructor(
	"Flex",
	{
		hasState = false,
		hasChildren = false,
		Args = {
			["FlexMode"] = 1,
		},
		Events = {},
		Generate = function(_thisWidget: any)
			local Flex = Instance.new("UIFlexItem")
			Flex.Name = "Iris_Flex"
			return Flex
		end,
		Update = function(thisWidget: any)
			local flex: UIFlexItem = thisWidget.Instance
			flex.FlexMode = thisWidget.arguments.FlexMode or Enum.UIFlexMode.None
		end,
		Discard = function(thisWidget: any)
			thisWidget.Instance:Destroy()
		end,
	} :: any
)

local function Flex(mode: Enum.UIFlexMode?)
	return Internal._Insert("Flex", { mode })
end

return Flex
