extends Node


func _on_wall_detector_area_entered(area: Area2D) -> void:
	area.get_parent().z_index = 4


func _on_wall_detector_area_exited(area: Area2D) -> void:
	area.get_parent().z_index = 1
