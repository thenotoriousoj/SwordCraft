extends Node

class_name TileGenerator
var tileArray = []
var totalPriority = 0
var rng
func _init(requestedSeed : int):
	rng = RandomNumberGenerator.new()
	rng.seed = requestedSeed
func generateTile():
	if (totalPriority <=0): return null
	var num = rng.randi_range(1, totalPriority)
	for tileObj in tileArray:
		var priority = tileObj["priority"]
		if (num <= priority):
			return tileObj["scene"] 
		else:
			num -= priority
func addTile(tileScene, priority):
	if (priority <= 0): push_error('Priority cannot be below 1')
	totalPriority += priority
	tileArray.append({"scene": tileScene, "priority": priority})
		
