local Lighting = game:GetService("Lighting")
local Selection = game:GetService("Selection")
local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/Extension")
local assets = require("@src/assets")
local types = require("@self/types")

local TAU = math.pi * 2

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-lighting",
	title = "Lighting",
	description = "Lossless changing of instance classes.",
	icon = { Image = assets.extensions.rocket },
	authors = { "Team Fireworks" },
})

local repositions: { types.Reposition } = {
	require("@self/repositions/line"),
}

local function repositionDirection(direction: Vector3)
	local latitude = math.atan2(direction.Z, math.sqrt(direction.X ^ 2 + direction.Y ^ 2))
	local longtitude = math.atan2(direction.Y * -1, direction.X * -1)

	local geographicalLatitude = (latitude / TAU) * 360 + 23.5
	local clockTime = (longtitude / TAU) * 24 - 6

	Lighting.ClockTime = clockTime % 24
	Lighting.GeographicLatitude = geographicalLatitude
end

local function useRepositionState(ctx: Extension.CommandContext): types.RepositionState
	return {
		sunDirection = Lighting:GetSunDirection(),
		cameraPosition = workspace.CurrentCamera.CFrame.Position,
		cameraDirection = workspace.CurrentCamera.CFrame.LookVector,
		mousePosition = ctx.mouse.Hit.Position,
		mouseDirection = ctx.mouse.UnitRay.Direction,
	}
end

for _, reposition in repositions do
	local initial: types.RepositionState? = nil
	local hasInitiallyClicked = false

	ext:newCommand({
		id = `reposition-via-{reposition.id}`,
		title = `Reposition Light Source via {reposition.title}`,
		description = "",

		renderInViewport = function(ctx: Extension.CommandContext)
			local isMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			if hasInitiallyClicked then
				if not isMouseDown then
					initial = nil
					hasInitiallyClicked = false
					ctx.trove:Clean()
					return
				end

				print("??!")

				local now = useRepositionState(ctx)
				initial = initial or now
				repositionDirection(reposition.getDirection(initial :: types.RepositionState, now))
			elseif isMouseDown then
				Selection:Set({})
				hasInitiallyClicked = true
			end
		end,
	})
end

return ext
