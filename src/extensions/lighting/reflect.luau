local function reflect(vector: Vector3, normal: Vector3): Vector3
	return vector - (2 * vector:Dot(normal) * normal)
end

return reflect
