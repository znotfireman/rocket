local Lighting = game:GetService("Lighting")
local Selection = game:GetService("Selection")
local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/Extension")
local assets = require("@src/assets")
local types = require("@self/types")

local TAU = math.pi * 2

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin

local sources = {
	{ id = "sun", title = "Sun", longtitudeFactor = 1, icon = assets.extensions.lighting.sun },
	{ id = "moon", title = "Moon", longtitudeFactor = -1, icon = assets.extensions.lighting.moon },
}

local repositions: { types.Reposition } = {
	require("@self/repositions/face"),
	require("@self/repositions/line"),
	require("@self/repositions/mouse"),
	require("@self/repositions/reflection"),
	require("@self/repositions/shadow"),
}

local ext = Extension.new(plugin, {
	id = "rocket-lighting",
	title = "Lighting",
	description = "Lossless changing of instance classes.",
	icon = { Image = assets.extensions.lighting.sun },
	authors = { "Team Fireworks" },
})

local function repositionDirection(direction: Vector3, longitudeFactor: number)
	local latitude = math.atan2(direction.Z, math.sqrt(direction.X ^ 2 + direction.Y ^ 2))
	local longtitude = math.atan2(direction.Y * -longitudeFactor, direction.X * -longitudeFactor)

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

for _, source in sources do
	for _, reposition in repositions do
		local initial: types.RepositionState? = nil
		local hasInitiallyClicked = false

		ext:newCommand({
			id = `reposition-{source.id}-via-{reposition.id}`,
			title = `Reposition {source.title} via {reposition.title}`,
			description = `Reposition the {source.title} by {reposition.describedBy}`,
			icon = { Image = source.icon },

			renderInViewport = function(ctx: Extension.CommandContext)
				if UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
					ctx.trove:Clean()
					return
				end

				local isMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
				if hasInitiallyClicked then
					if not isMouseDown then
						initial = nil
						hasInitiallyClicked = false
						ctx.trove:Clean()
						return
					end

					local now = useRepositionState(ctx)
					initial = initial or now
					local direction = reposition.getDirection(initial :: types.RepositionState, now)
					if direction then
						repositionDirection(direction, source.longtitudeFactor)
					end
				elseif isMouseDown then
					Selection:Set({})
					hasInitiallyClicked = true
				end
			end,
		})
	end
end

return ext
