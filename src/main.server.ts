assert(plugin, `Rocket must be ran as a plugin`);

import { atom, computed, subscribe } from "@rbxts/charm";
import Iris from "@rbxts/iris";
import { ChangeHistoryService, CoreGui } from "@rbxts/services";
import { Trove } from "@rbxts/trove";
import { Palette, PaletteProps } from "./components/palette";
import { RocketCommand, RocketExtension, RocketApplication } from "./framework";
import Object from "@rbxts/object-utils";
import { UserInputService } from "@rbxts/services";
import fzy from "./vendor/fzy";

const pluginTrove = new Trove();
pluginTrove.add(plugin.Unloading.Connect(() => pluginTrove.destroy()));

const commandByName = new Map<string, typeof RocketCommand>();
const applicationByName = new Map<string, typeof RocketApplication>();
const extensionByName = new Map<string, typeof RocketExtension>();

function addNamed(map: Map<string, typeof RocketExtension>, value: typeof RocketExtension) {
	const { name } = value;
	if (map.has(name)) throw `Duplicate extension named ${name}`;
	map.set(name, value);
}

function collectExtension(ext: typeof RocketExtension) {
	// TODO: tf
	const mt = getmetatable(ext);
	const index = typeIs(mt, "table") && "__index" in mt && mt.__index;
	const isCommand = index === RocketCommand,
		isPanel = index === RocketApplication;

	if (isCommand) addNamed(commandByName, ext);
	if (isPanel) addNamed(applicationByName, ext);
	if (isCommand || isPanel) addNamed(extensionByName, ext);
}

function collectModules(modules: Instance[]) {
	for (const mod of modules) {
		if (mod.IsA("ModuleScript")) {
			const [requireSuccess, ext] = pcall(require, mod);
			if (!requireSuccess) {
				warn("Failed to require extension", mod.Name, "because:", ext);
				continue;
			}

			if (typeIs(ext, "table")) {
				collectExtension(ext as typeof RocketExtension);
				for (const [_, value] of pairs(ext)) {
					if (typeIs(value, "table")) collectExtension(value as typeof RocketExtension);
				}
			}
		}
	}
}

function mountUi() {
	const extensionFolder = plugin.FindFirstChild("extensions", true);
	assert(extensionFolder, "Missing extension folder");
	collectModules(extensionFolder.GetChildren());

	const commands = new Set(Object.values(commandByName));
	const applications = new Set(Object.values(applicationByName));
	const extensions = new Set(Object.values(extensionByName));

	const commandNames = Object.keys(commandByName).sort();
	const applicationNames = Object.keys(applicationByName).sort();
	const extensionNames = Object.keys(extensionByName).sort();

	const isPaletteVisible = atom(false);
	const isPaletteFocused = atom(false);
	const selectedIndex = atom(0);
	const search = atom("");
	const searchResults = computed(() => {
		const searchNow = search();
		let extenstionHaystack = table.clone(extensionNames);
		if (searchNow !== "") {
			const results = fzy.filter(searchNow, extensionNames, false);
			table.sort(results, (lhs, rhs) => lhs[2] < rhs[2]);
			extenstionHaystack = table.create(results.size());
			for (const [idx] of results) extenstionHaystack.push(extensionNames[idx - 1]);
		}
		return extenstionHaystack;
	});

	function run(ext: typeof RocketExtension) {
		isPaletteVisible(false);

		const cmdCtor = ext as typeof RocketCommand;
		if (commands.has(cmdCtor)) {
			const cmdTrove = pluginTrove.extend();
			const cmd = new cmdCtor(plugin, cmdTrove);
			cmd.run();
			cmdTrove.destroy();
		}
	}

	const paletteProps: PaletteProps = {
		commands,
		applications,

		extensions,
		extensionByName,
		extensionNames,

		isPaletteVisible,
		isPaletteFocused,
		selectedIndex,
		search,
		searchResults,

		run,
	};

	const launchAction = plugin.CreatePluginAction(
		"rocket.launch",
		"Launch Rocket",
		"Launch the Rocket command palette",
		"",
		true,
	);

	pluginTrove.add(launchAction.Triggered.Connect(() => isPaletteVisible(!isPaletteVisible())));

	let paletteInputTrove = pluginTrove.extend();
	pluginTrove.add(
		subscribe(isPaletteVisible, () => {
			search("");
			selectedIndex(0);
			paletteInputTrove.clean();
			paletteInputTrove.add(
				UserInputService.InputBegan.Connect((input) => {
					const keycode = input.KeyCode;
					switch (keycode) {
						case Enum.KeyCode.Up:
							selectedIndex(math.max(selectedIndex() - 1, 0));
							break;
						case Enum.KeyCode.Down:
							selectedIndex(math.min(selectedIndex() + 1, searchResults().size() - 1));
							break;
						case Enum.KeyCode.Return:
							paletteProps.run(extensionByName.get(extensionNames[selectedIndex()])!);
							break;
					}
				}),
			);
		}),
	);

	const ui = new Instance("ScreenGui");
	ui.Name = "Rocket";
	ui.DisplayOrder = 1000;
	ui.Parent = CoreGui;

	Iris.Init(ui);
	Iris.PushConfig(Iris.TemplateConfig.sizeClear);
	Iris.PushConfig({ RichText: true, FrameBorderSize: 0 });
	Iris.Connect(() => {
		if (isPaletteVisible()) Palette(paletteProps);
	});

	pluginTrove.add(() => Iris.Shutdown());
}

function start() {
	mountUi();
}

try {
	start();
} catch (e) {
	warn("Failed to start Rocket:", e);
	pluginTrove.destroy();
}
