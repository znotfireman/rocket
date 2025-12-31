import { RocketApplication, RocketCommand } from "#/framework";
import { Window } from "@rbxts/iris";
import { Selection } from "@rbxts/services";

const STUDS = table.freeze({
	[1]: "stud",
	[0.5]: "half stud",
	[0.25]: "quarter stud",
	[0.1]: "tenth stud",
});

function createRoundCommands(size: number, name: string): (typeof RocketCommand)[] {
	class RoundSizeCommand extends RocketCommand {
		static name = `Round Sizes to Nearest ${name}`;
		override run(): void {
			for (const selected of Selection.Get()) {
				if (!selected.IsA("BasePart")) continue;
				selected.Size = new Vector3(
					math.round(selected.Size.X / size) * size,
					math.round(selected.Size.Y / size) * size,
					math.round(selected.Size.Z / size) * size,
				);
			}
		}
	}

	class RoundPositionCommand extends RocketCommand {
		static name = `Round Positions to Nearest ${name}`;
		override run(): void {
			for (const selected of Selection.Get()) {
				if (!selected.IsA("BasePart")) continue;
				selected.Position = new Vector3(
					math.round(selected.Position.X / size) * size,
					math.round(selected.Position.Y / size) * size,
					math.round(selected.Position.Z / size) * size,
				);
			}
		}
	}

	return [RoundSizeCommand, RoundPositionCommand];
}

export = [
	...createRoundCommands(1, "Stud"),
	...createRoundCommands(0.5, "Half Stud"),
	...createRoundCommands(0.25, "Quarter Stud"),
	...createRoundCommands(0.1, "Tenth Stud"),
];
