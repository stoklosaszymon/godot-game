extends Node2D

var is_open = false

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_open = !is_open
		if is_open:
			open()
		else: 
			close()

func open():
	$AnimatedSprite2D.play("open")
	$CollisionPolygon2D.set_deferred("disabled", true)

func close():
	$AnimatedSprite2D.play("close")
	$CollisionPolygon2D.set_deferred("disabled", false)
