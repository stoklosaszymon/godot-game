extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var items: Array[Resource] = [
	preload("res://items/key.tres"),
	preload("res://items/key.tres"),
	preload("res://items/key.tres"),
	preload("res://items/key.tres"),
	preload("res://items/key.tres"),
]
@onready var hud = get_node("/root/main/HUD")

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
		if GameManager.inventory == null:
			hud.instantiate_inventory()
			
		if GameManager.target_inventory == null:
			hud.instantiate_target_inventory()
			GameManager.target_inventory.items = items
			GameManager.target_inventory.target = self
			GameManager.target_inventory.open();
			sprite.play("open")
	else:
		if GameManager.inventory != null:
			GameManager.inventory.close()
		if GameManager.target_inventory != null:
			GameManager.target_inventory.close()
		sprite.play("close")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = false
		if GameManager.inventory != null:
			GameManager.inventory.close()
		if GameManager.target_inventory != null:
			GameManager.target_inventory.close()
		
		if is_open:
			toggle_chest()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby:
		toggle_chest()
