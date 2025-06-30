extends Node

var player : Node = null
var previous_scene_path = "res://main.tscn"
var directional_light: DirectionalLight2D = null;
var inventory: Node = null;
var target_inventory: Node = null;
var target_inventory_id = null;
var curently_gathered: Node = null;

var chests_data = {
	"chest_id_1": [
		preload("res://resources/key.tres").duplicate(),
		preload("res://resources/torch.tres").duplicate()
		],
	"chest_id_2": [
		preload("res://resources/key.tres").duplicate(),
	],	
}

func _init() -> void:
	for key in chests_data:
		var resources = chests_data[key]
		var items: Array[ItemData] = []
		for resource in resources:
			items.append(resource)
		chests_data[key] = items


func add_item_to_chest(item: ItemData):
	if item in PlayerState.inventory:
		PlayerState.inventory.erase(item)
		chests_data[target_inventory_id].append(item)

func add_item_to_inventory(item: ItemData) -> void:
	if target_inventory_id != null:
		if item in chests_data[target_inventory_id]:
			chests_data[target_inventory_id].erase(item)
			PlayerState.inventory.append(item)

func get_target_inventory():
	return chests_data.get(target_inventory_id)
	
func claim_all():
	PlayerState.inventory.append_array(chests_data[target_inventory_id])
	chests_data[target_inventory_id] = []
