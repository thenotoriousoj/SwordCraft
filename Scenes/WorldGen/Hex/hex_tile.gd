extends Node3D

var tileSize: float = 4
var heightMap: Array = []
var texture = preload("res://Assets/Textures/PlainsTile.jpg")
var wall_texture = preload("res://Assets/Textures/MountainTile.jpg")
@onready var mesh_instance = $MeshInstance3D
@onready var collisionShape = $StaticBody3D/CollisionShape3D
func _ready(): 
	var mesh = generate_hex()
	mesh_instance.mesh = mesh
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = texture
	mesh_instance.material_override = mat
	finalize_collision()
	pass

func finalize_collision():
	var shape = mesh_instance.mesh.create_trimesh_shape()
	collisionShape.shape = shape
	
func generate_hex():
	# Array must be done in the following order [right, br, bl, left, tl, tr]
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(0)
	var center_uv = Vector2(0.5, 0.5)

	var center = Vector3(0, 0, 0)

	# Hex corners (flat-top orientation)
	var angles = [
		deg_to_rad(0),
		deg_to_rad(60),
		deg_to_rad(120),
		deg_to_rad(180),
		deg_to_rad(240),
		deg_to_rad(300)
	]

	var radius = tileSize

	var corners = []

	for i in range(6):
		var x = cos(angles[i]) * radius
		var z = sin(angles[i]) * radius

		var y = 0
		if heightMap.size() == 6:
			y = heightMap[i]

		corners.append(Vector3(x, y, z))
	if heightMap.size() == 6: center.y = heightMap.reduce(func(acc, num): return acc + num) / 6
	# Build triangles (center → edge pairs)
	for i in range(6):
		var a = corners[i]
		var b = corners[(i + 1) % 6]

		var uv_a = Vector2(cos(angles[i]), sin(angles[i])) * 0.5 + Vector2(0.5, 0.5)
		var uv_b = Vector2(cos(angles[(i + 1) % 6]), sin(angles[(i + 1) % 6])) * 0.5 + Vector2(0.5, 0.5)

		# triangle
		st.set_uv(center_uv)
		st.add_vertex(center)

		st.set_uv(uv_a)
		st.add_vertex(a)

		st.set_uv(uv_b)
		st.add_vertex(b)
	st.generate_normals()
	var final_mesh = st.commit()
	return final_mesh
