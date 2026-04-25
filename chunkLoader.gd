extends Node3D

@onready var MapManager = preload("res://Map_Manager.gd")
@onready var hex_grass = preload('res://Hex_Grass.tscn')
@onready var hex_desert = preload('res://Hex_Desert.tscn')
@onready var hex_mountain = preload('res://Hex_Mountain.tscn')
@onready var hex_forest = preload('res://Hex_Forest.tscn')

var Map
var chunkSize : int
var tileWidth : float
var tileHeight : float
var tileSize : float
var chunk_x : int
var chunk_z : int
var seed : int
var collision_body
var collision_enabled
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Map = MapManager.new(seed)
	Map.addTile(hex_grass, 10)
	Map.addTile(hex_desert, 1)
	Map.addTile(hex_forest, 2)
	Map.addTile(hex_mountain, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generate():
	for x in range(chunkSize):
		for z in range(chunkSize):
			var tile_scene = Map.generateTile()
			var hex = tile_scene.instantiate()
			hex.scale = Vector3(tileSize, 1, tileSize)
			add_child(hex)
			var x_pos = x * tileWidth
			var z_pos = z * tileHeight + (x % 2) * (tileHeight / 2)
			hex.position = Vector3(x_pos, 0, z_pos)
			
