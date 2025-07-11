extends Node2D

var is_open = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_open = !is_open
		if is_open:
			$AnimatedSprite2D.play("open")
			$CollisionPolygon2D.set_deferred("disabled", true)
		else: 
			$AnimatedSprite2D.play("close")
			$CollisionPolygon2D.set_deferred("disabled", false)

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	print("enterd")
	z_index = 3


func _on_area_2d_2_area_exited(area: Area2D) -> void:
	print("exited")
	z_index = 5
