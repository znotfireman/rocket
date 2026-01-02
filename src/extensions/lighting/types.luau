export type RepositionState = {
	sunDirection: Vector3,
	cameraPosition: Vector3,
	cameraDirection: Vector3,
	mousePosition: Vector3,
	mouseDirection: Vector3,
}

export type Reposition = {
	id: string,
	title: string,
	describedBy: string,

	getDirection: (initial: RepositionState, now: RepositionState) -> Vector3?,
}

return nil
