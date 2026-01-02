local Extension = require("@src/Extension")
local Iris = require("@iris/Iris")
local assets = require("@src/assets")
local useExtensionPageState = require("./useExtensionPageState")

local function ExtensionListing(
	extension: Extension.Extension,
	extensionsCollapsed: { [Extension.Extension]: true },
	state: useExtensionPageState.ExtensionPageState,
	layoutOrder: number
)
	local extensionIcon = extension._metadata.icon

	Iris.PushId(extension._metadata.id)
	local header = Iris.ButtonGroup(UDim2.fromScale(1, 0))
	header.Instance.LayoutOrder = layoutOrder
	if header.clicked() then
		state.selected:set(extension)
	end

	-- If the caret was the same size as the icon, it would be misaligned.
	-- ...Noone's going to notice this right?
	local _expand = Iris.ImageButton(
		extensionsCollapsed[extension] and assets.icons.caretright or assets.icons.caretdown,
		UDim2.fromOffset(17, 17)
	)

	if header.clicked() then
		extensionsCollapsed[extension] = if extensionsCollapsed[extension] then nil else true
	end

	Iris.Icon(extensionIcon, UDim2.fromOffset(18, 18))
	Iris.Text(extension._metadata.title)

	Iris.PopId()
	Iris.End()
end

return ExtensionListing
