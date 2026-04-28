extends Node3D

@onready var MapManager = preload("res://Scripts/Map_Manager.gd")
@onready var HexTemplate = preload("res://Scenes/WorldGen/Hex/Hex_Template.tscn")
var Map
var chunkSize : int
var tileWidth : float
var tileHeight : float
var tileSize : float
var chunk_x : int
var chunk_z : int
var chunkSeed : int
var collision_body
var collision_enabled
var height_value
var elevation_noise
var hex_key = {}
var worldGrid
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Map = MapManager.new(chunkSeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generate():
	for x in range(chunkSize):
		for z in range(chunkSize):
			var tile = Map.generateTile("lowerFields")
			var hex = HexTemplate.instantiate()
			hex.texture = tile.texture
			hex.tileSize = tileSize
			#hex.scale = Vector3(tileSize, 1, tileSize)

			# Getting position values
			var x_pos = x * tileWidth
			var offset = x % 2
			var z_pos = z * tileHeight + (x % 2) * (tileHeight / 2)
			var worldKeyX = x + (chunkSize * chunk_x)
			var worldKeyZ = z + (chunkSize * chunk_z)
			var y_pos = elevation_noise.get_noise_2d(worldKeyX, worldKeyZ) * (20 * tileSize) + (20 * tileSize)
			hex.position = Vector3(x_pos, y_pos, z_pos)
			# Modify hex to mesh with terrain
			var tl = elevation_noise.get_noise_2d(worldKeyX - 1, worldKeyZ - 1 + offset) * (20 * tileSize) + (20 * tileSize)
			var t = elevation_noise.get_noise_2d(worldKeyX, worldKeyZ - 1) * (20 * tileSize) + (20 * tileSize)
			var tright = elevation_noise.get_noise_2d(worldKeyX + 1, worldKeyZ - 1 + offset) * (20 * tileSize) + (20 * tileSize)
			var br = elevation_noise.get_noise_2d(worldKeyX + 1, worldKeyZ + offset) * (20 * tileSize) + (20 * tileSize)
			var b = elevation_noise.get_noise_2d(worldKeyX, worldKeyZ + 1) * (20 * tileSize) + (20 * tileSize)
			var bl = elevation_noise.get_noise_2d(worldKeyX - 1, worldKeyZ + offset) * (20 * tileSize) + (20 * tileSize)
			var right = (tright + br) / 2 - y_pos
			var bRight = (b + br) / 2 - y_pos
			var bLeft = (b + bl) / 2 - y_pos
			var left = (tl + bl) / 2 - y_pos
			var tLeft = (tl + t) / 2 - y_pos
			var tRight = (t + tright) / 2 - y_pos
			hex.heightMap = [right, bRight, bLeft, left, tLeft, tRight]
			if (worldKeyX == 0 && worldKeyZ == 0): print(hex.heightMap)
			add_child(hex)
			# Storing hex position in chunk and world
			tile["instance"] = hex
			hex_key[Vector2i(x, z)] = tile
			var hexWorldPos = Vector2i(worldKeyX,worldKeyZ)
			worldGrid[hexWorldPos] = {"hex": tile}
			
