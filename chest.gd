extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var chest_id: String = ""
@export var is_locked = false

var player_nearby := false
var chest_clicked := false

func _ready() -> void:
	sprite.play("closed")
	
func toggle_chest():
	var hud = GameManager.hud
	if is_locked:
		return

	if GameManager.target_inventory == null:
		if GameManager.inventory == null:
			hud.instantiate_inventory()
		hud.instantiate_target_inventory()
		GameManager.target_inventory_id = chest_id;
		GameManager.target_inventory.open();
		sprite.play("open")
	else:
		if GameManager.inventory != null:
			GameManager.inventory.close()
		GameManager.target_inventory.close()
		sprite.play("close")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = true
		z_index = -1;

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = false
		if GameManager.inventory != null:
			GameManager.inventory.close()
		if GameManager.target_inventory != null:
			GameManager.target_inventory.close()
		z_index = 3;

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby and event.button_index == 1:
		toggle_chest()

func _on_area_2d_mouse_entered() -> void:
	if is_locked:
		CursorManager.set_cursor_lock()

func _on_area_2d_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
