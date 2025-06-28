extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = get_node("/root/main/HUD")
@export var chest_id: String = ""


var is_open := false
var player_nearby := false
var chest_clicked := false
		
func _ready() -> void:
	sprite.play("closed")
	
func toggle_chest():
	is_open = !is_open

	if is_open:
		if GameManager.inventory == null:
			hud.instantiate_inventory()
			
		if GameManager.target_inventory == null:
			hud.instantiate_target_inventory()
			GameManager.target_inventory_id = chest_id;
			GameManager.target_inventory.open();
			sprite.play("open")
	else:
		if GameManager.inventory != null:
			GameManager.inventory.close()
		if GameManager.target_inventory != null:
			GameManager.target_inventory.close()
		sprite.play("close")

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("area entered")
	if area.name == "PlayerArea":
		player_nearby = true
	z_index = 0;

func _on_area_2d_area_exited(area: Area2D) -> void:
	print("area left")
	if area.name == "PlayerArea":
		player_nearby = false
		if GameManager.inventory != null:
			GameManager.inventory.close()
		if GameManager.target_inventory != null:
			GameManager.target_inventory.close()
		
		if is_open:
			toggle_chest()
			
		z_index = 1;


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby:
		toggle_chest()
