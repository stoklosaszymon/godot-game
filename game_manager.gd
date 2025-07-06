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
		preload("res://resources/torch.tres").duplicate(),
		preload("res://resources/pickaxe.tres").duplicate(),
				preload("res://resources/axe.tres").duplicate()
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
			
func drop_item(item_data: Resource, position: Vector2):
	var dropped_scene = preload("res://dropped_item.tscn")
	var dropped_instance = dropped_scene.instantiate()
	dropped_instance.item_data = item_data
	dropped_instance.global_position = player.global_position
	get_tree().current_scene.get_node("/root/main/MainMap").add_child(dropped_instance)
	dropped_instance.queue_redraw()
	PlayerState.inventory.erase(item_data)
