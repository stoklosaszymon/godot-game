extends Node2D

var target_node = "Gate"

var triggered = false;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		triggered = !triggered
		if triggered:
			get_parent().get_node(target_node).open()
			$AnimatedSprite2D.play("on")
		else:
			get_parent().get_node(target_node).close()
			$AnimatedSprite2D.play("off")
