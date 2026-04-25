extends Node3D


class_name Chunk
var chunk_x: int
var chunk_z: int
var seed: int
@onready var MapManager = preload('res://Map_Manager.gd').new()
var Map
@onready var hex_holder = $HexHolder

func _init(seed, chunkstart_x, chunkstart_z):
	seed = seed
	chunk_x = chunkstart_x
	chunk_z = chunkstart_z

	
const CHUNK_SIZE := 16

func generate():
	var rng = RandomNumberGenerator.new()
	rng.seed = seed
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var tile = Map.generateTile().instantiate()
			hex_holder.add_child(tile)
			var world_x = chunk_x * CHUNK_SIZE + x
			var world_z = chunk_z * CHUNK_SIZE + z
			tile.position = Vector3(world_x, 0, world_z)
			#tile.set_meta("world_x", world_x)
			#tile.set_meta("world_z", world_z)
			#tile.set_meta("value", rng.randi())
			
#func generate_map(tileMap):
#	for x in range(map_radius):
#		for z in range(map_radius):
#			var hex = tileMap.generateTile().instantiate()
#			add_child(hex)
#			var x_pos = x * (hexTileSize * 1.5)
#			var z_pos = z * (sqrt(3) * hexTileSize) + (x % 2) * (sqrt(3)/2 * hexTileSize)
#			hex.position = Vector3(x_pos, 0, z_pos)
			
