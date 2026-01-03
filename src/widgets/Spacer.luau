local Iris = require("@pkgs/Iris")

-- Internal.WidgetConstructor(
-- 	"Spacer",
-- 	{
-- 		hasState = false,
-- 		hasChildren = false,
-- 		Args = {
-- 			["Size"] = 1,
-- 		},
-- 		Events = {},
-- 		Generate = function(_thisWidget: any)
-- 			local Spacer = Instance.new("Frame")
-- 			Spacer.Name = "Iris_Spacer"
-- 			Spacer.AutomaticSize = Enum.AutomaticSize.XY
-- 			Spacer.Size = UDim2.fromOffset(0, 0)
-- 			Spacer.BackgroundTransparency = 1

-- 			return Spacer
-- 		end,
-- 		Update = function(thisWidget: any)
-- 			local spacer: Frame = thisWidget.Instance
-- 			if spacer then
-- 				spacer.Size = if thisWidget.arguments.Size
-- 					then (UDim2.new :: any)(0, thisWidget.arguments.Size, 0, thisWidget.arguments.Size)
-- 					else UDim2.new()
-- 			end
-- 		end,
-- 		Discard = function(thisWidget: any)
-- 			thisWidget.Instance:Destroy()
-- 		end,
-- 	} :: any
-- )

local function Spacer(size: number)
	return Iris.Image({ "", UDim2.fromOffset(size, size) })
end

return Spacer
