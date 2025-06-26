extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var items: Array[Resource] = [
	preload("res://items/key.tres"),
]
@onready var chest_ui = get_node("/root/main/HUD/TargetInventory")
@onready var inventory = get_node("/root/main/HUD/Inventory")
	
var is_open := false
var player_nearby := false
var chest_clicked := false

func clear():
	items = []

func _ready() -> void:
	sprite.play("closed")
	
func toggle_chest():
	is_open = !is_open
	if is_open:
		chest_ui.items = items;
		sprite.play("open")
		if chest_ui:
			chest_ui.open(items)
			inventory.open()
		else:
			print("chest_ui is null!")
	else:
		chest_ui.close()
		inventory.close()
		sprite.play("close")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = false
		chest_ui.close()
		inventory.close();
		if is_open:
			toggle_chest()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby:
		toggle_chest()
