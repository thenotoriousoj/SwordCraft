extends Node

class_name TileGenerator
var rng
var textures = {
	"grass": preload("res://Assets/Textures/PlainsTile.jpg"),
	"mountain": preload("res://Assets/Textures/MountainTile.jpg"),
	"desert": preload("res://Assets/Textures/DesertTile.jpg"),
	"forest": preload("res://Assets/Textures/PineForestTile.jpg"),
}
var world_generator = {
	"lowerFields": [
		{"type": "grass", "priority": 5},
		{"type": "forest", "priority": 4},
		{"type": "mountain", "priority": 1},
		{"type": "desert", "priority": 3},
	],
	"upperFields": [
		{"type": "grass", "priority": 4},
		{"type": "forest", "priority": 5},
		{"type": "mountain", "priority": 3},
		{"type": "desert", "priority": 1},
	],
}
func _init(requestedSeed : int):
	rng = RandomNumberGenerator.new()
	rng.seed = requestedSeed

func generateTile(biome):
	var worldPool = world_generator[biome]
	var totalPriority: int = 0
	for hextype in worldPool:
		totalPriority += hextype.priority
			
	if (totalPriority <=0): return null
	var num = rng.randi_range(1, totalPriority)
	for tileObj in worldPool:
		var priority = tileObj["priority"]
		if (num <= priority):
			var hex = {
				"type": tileObj["type"],
				"biome": biome,
				"texture": textures[tileObj["type"]]
			}
			return hex
		else:
			num -= priority
