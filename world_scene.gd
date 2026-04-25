extends Node3D

@export var Render_Distance := 2
@export var Tile_Size := 2
@export var Chunk_Size := 16
@export var worldSeed : int
@export var Simulation_Distance := 2
var RNG = RandomNumberGenerator.new()

@onready var chunkManager = preload("res://ChunkManager.gd")
@onready var player = preload("res://Player.tscn")
var playerInstance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (worldSeed == 0):
		RNG.randomize()
		worldSeed = RNG.seed
	playerInstance = player.instantiate()
	add_child(playerInstance)
	playerInstance.position = Vector3(0, 2, 0)
	await get_tree().process_frame
	
	var chunkLoader = chunkManager.new(worldSeed, playerInstance, Render_Distance, Chunk_Size, Tile_Size)
	add_child(chunkLoader)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
