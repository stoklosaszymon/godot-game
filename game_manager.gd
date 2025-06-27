extends Node

var player : Node = null
var previous_scene_path = "res://main.tscn"
var directional_light: DirectionalLight2D = null;
var inventory: Node = null;
var target_inventory: Node = null;

var chests_data = {
	"chest_id_1": [
		preload("res://resources/key.tres").duplicate()
		],
}

func _init() -> void:
	for key in chests_data:
		var resources = chests_data[key]
		var items: Array[ItemData] = []
		for resource in resources:
			items.append(resource)
		chests_data[key] = items
