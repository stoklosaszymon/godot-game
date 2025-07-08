extends Node2D

var item_data: Resource

func _ready():
	$TextureRect.texture = item_data.icon
	$TextureRect.custom_minimum_size = Vector2(10, 10)
	$TextureRect.set_anchors_preset(Control.PRESET_CENTER)

func pick_up():
	PlayerState.inventory.append(item_data)
	if GameManager.inventory != null:
		GameManager.inventory.open()
	queue_free()
	CursorManager.set_cursor_arrow()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pick_up()


func _on_dropped_item_area_mouse_entered() -> void:
	CursorManager.set_cursor_open_hand()


func _on_dropped_item_area_mouse_exited() -> void:
	CursorManager.set_cursor_arrow()
