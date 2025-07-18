extends Node


func _on_wall_detector_area_entered(area: Area2D) -> void:
	area.get_parent().z_index = 4


func _on_wall_detector_area_exited(area: Area2D) -> void:
	if !PlayerState.is_climbing:
		area.get_parent().z_index = 1

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_minimap"):
		GameManager.togggle_map()


func _on_leave_cave_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		SceneTransition.go_back()
