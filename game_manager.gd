extends Node

var player : Node = null
var main_map : Node = null
var battle_instance: Node = null
var inventory: Node = null
var hud: Node = null
var minimap: Node = null

var previous_scene_path = "res://main.tscn"
var directional_light: DirectionalLight2D = null

var target_inventory: Node = null
var target_inventory_id = null
var curently_gathered: Node = null

var current_day = 0;
var current_hour = 8;
var current_minutes = 0;
var world_time: float = 0.0

var chests_data: Dictionary[String, Array] = {
	"chest_id_1": [
		preload("res://resources/tools/torch.tres").duplicate(),
		preload("res://resources/tools/pickaxe.tres").duplicate(),
		preload("res://resources/tools/axe.tres").duplicate()
		],
	"chest_id_2": [
		preload("res://resources/tools/key.tres").duplicate(),
	],	
}

var world_enemy_data: Dictionary[String, Array] = {
	"enemy_id_1": [
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
	],
	"enemy_id_2": [
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://archer_unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
	],
	"enemy_id_3": [
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
		load("res://unit.tscn").duplicate(),
	],
	"enemy_id_4": [
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
		load("res://squire_unit.tscn").duplicate(),
	],
	"enemy_id_5": [
		load("res://knight_unit.tscn").duplicate(),
	],
}

func _init() -> void:
	transform_chest_resource_to_item_data()

func add_item_to_target(item: ItemData, target: Array[ItemData]) -> void:
	var found_item = find_item_by_name(item.item_name, target)
	if (found_item != null):
		found_item.quantity += item.quantity
	else:
		target.append(item)
			
func remove_item_from_target(item: ItemData, target: Array[ItemData]) -> void:
	if item in target:
		target.erase(item)
			
func remove_x_of_item_from_target(item: ItemData, target: Array[ItemData], count: int) -> void:
	if item in target:
		if item.quantity > count:
			item.quantity -= count
		else:
			remove_item_from_target(item, target)

func get_target_inventory():
	return chests_data.get(target_inventory_id)
	
func claim_all():
	for item in chests_data[target_inventory_id]:
		add_item_to_target(item, PlayerState.inventory)
	chests_data[target_inventory_id] = []
			
func drop_item(item_data: Resource):
	var dropped_scene = preload("res://dropped_item.tscn")
	var dropped_instance = dropped_scene.instantiate()
	dropped_instance.item_data = item_data
	dropped_instance.global_position = player.global_position
	get_tree().current_scene.add_child(dropped_instance)
	dropped_instance.queue_redraw()
	PlayerState.inventory.erase(item_data)
	GameManager.inventory.open()

func find_item_by_name(i_name: String, target: Array[ItemData]) -> ItemData:
	for item in target:
		if item.item_name == i_name:
			return item
	return null

func togggle_map():
	var map = get_tree().get_current_scene().get_node("HUD/Map")
	map.visible = !map.visible

var resource_textures := {
	"iron_ore": preload("res://Assets/Resources/iron_ore.png"),
	"gold_ore": preload("res://Assets/Resources/gold_ore.png"),
	"ruby_ore": preload("res://Assets/Resources/ruby_ore.png"),
	"coal_ore": preload("res://Assets/Resources/coal_ore.png"),
}

var recruitment_buildings: Dictionary[String, int] = {
	"recruit_id_1": 2,
	"recruit_id_2": 3,
	"recruit_id_3": 1,
	"recruit_id_4": 1,
}

var unit_costs: Dictionary[String, int] = {
	"Unit": 100,
	"Squire": 200,
	"Knight": 500,
	"Healer": 200,
	"Archer": 100,
	"Mage": 200
}

func update_time(day_index, hour, minutes):
	current_day = day_index
	current_hour = hour
	current_minutes = minutes

func transform_chest_resource_to_item_data():
	for key in chests_data:
		var resources = chests_data[key]
		var items: Array[ItemData] = []
		for resource in resources:
			items.append(resource)
		chests_data[key] = items
