local ButtonGroup = require("@src/components/foundations/ButtonGroup")
local Extension = require("@src/lib/Extension")
local Icon = require("@src/lib/Icon")
local Iris = require("@pkgs/Iris")
local assets = require("@src/assets")
local types = require("@src/components/settings/types")

local extensions = {} :: types.SettingPage
extensions.title = "Extensions"
extensions.tabIcon = assets.icons.extension

function extensions.render()
	local _showEnabled = Iris.State(true)
	local _showDisabled = Iris.State(true)
	local showCore = Iris.State(true)
	local showThirdParty = Iris.State(true)

	local collapsedExtensions = Iris.State({} :: { [Extension.Extension]: true })

	-- HACK: menus are fucked with window styling and ion feel like making it
	-- good
	Iris.PushConfig({
		CellPadding = Iris.TemplateConfig.sizeClear.CellPadding,
		WindowPadding = Iris.TemplateConfig.sizeClear.WindowPadding,
		ItemSpacing = Iris.TemplateConfig.sizeClear.WindowPadding,
	})
	Iris.SameLine({ 4 })
	local massCollapse: boolean? = nil
	Iris.Menu({ "Toggle All" })
	if Iris.MenuItem({ "Uncollasped" }).clicked() then
		massCollapse = false
	end
	if Iris.MenuItem({ "Collasped" }).clicked() then
		massCollapse = true
	end
	Iris.End()
	Iris.Menu({ "Filters" })
	Iris.MenuToggle({ "Show Enabled Extensions" })
	Iris.MenuToggle({ "Show Disabled Extensions" })
	Iris.Separator()
	Iris.MenuToggle({ "Show Core Extensions" }, { isChecked = showCore })
	Iris.MenuToggle({ "Show Third-Party Extensions" }, { isChecked = showThirdParty })
	Iris.End()
	Iris.InputText({ "", "Search for commands..." })
	Iris.End()
	Iris.PopConfig()

	Iris.SeparatorText({ "" })

	local extensionsCollapsed = collapsedExtensions:get()
	for i, extension in Extension.sortedByTitle() do
		local isCoreExtension = extension:isCore()
		if not (showCore:get() and isCoreExtension) then
			continue
		elseif showThirdParty:get() and not isCoreExtension then
			continue
		end

		if massCollapse ~= nil then
			extensionsCollapsed[extension] = massCollapse or nil
		end

		local extensionIcon = extension._metadata.icon
		Iris.PushId(extension._metadata.id)
		local header = ButtonGroup(UDim2.fromScale(1, 0))
		local headerLayoutOrder = i * 1000
		header.Instance.LayoutOrder = headerLayoutOrder
		if header.clicked() then
			extensionsCollapsed[extension] = if extensionsCollapsed[extension] then nil else true
		end
		Iris.Image({
			extensionsCollapsed[extension] and assets.icons.caretright or assets.icons.caretdown,
			UDim2.fromOffset(17, 17),
		})
		Icon.renderIcon(extensionIcon, UDim2.fromOffset(18, 18))
		Iris.Text({ extension._metadata.title })
		Iris.PopId()
		Iris.End()

		if extensionsCollapsed[extension] then
			continue
		end

		Iris.PushId(extension._metadata.id .. "/commands")
		Iris.Indent().Instance.LayoutOrder = headerLayoutOrder + 1
		if next(extension._commands) == nil then
			Iris.Text({ "<i>This extension has no commands.</i>" })
		else
			for _, cmd in extension._commands do
				Iris.PushId(cmd:formatId())
				ButtonGroup(UDim2.fromScale(1, 0))
				Icon.renderIcon(cmd._metadata.icon or extensionIcon, UDim2.fromOffset(18, 18))
				Iris.Text({ cmd._metadata.title })
				Iris.End()
				Iris.PopId()
			end
		end
		Iris.End()
		Iris.PopId()
	end
	collapsedExtensions:set(extensionsCollapsed)
end

return extensions
