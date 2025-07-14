extends Node2D

func _on_bottom_area_entered(area: Area2D) -> void:
	if PlayerState.is_upladder == true:
		PlayerState.is_climbing = false
		PlayerState.setWalkSprite()
		PlayerState.is_upladder = false
		GameManager.player.colision.set_deferred("disabled", false)

func _on_top_area_entered(area: Area2D) -> void:
	if PlayerState.is_upladder == false:
		PlayerState.is_climbing = false
		PlayerState.setWalkSprite()
		PlayerState.is_upladder = true
		GameManager.player.colision.set_deferred("disabled", false)

func _on_ladder_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		GameManager.player.z_index = 5;
		PlayerState.climb_ladder()
		if PlayerState.is_upladder:
			GameManager.player.global_position = Vector2(global_position.x, global_position.y - 60)
		else:
			GameManager.player.global_position = Vector2(global_position.x + 10, global_position.y + 60)

		GameManager.player.colision.set_deferred("disabled", true)
