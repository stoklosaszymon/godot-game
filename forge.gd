extends StaticBody2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		area.get_parent().z_index = 4;

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		area.get_parent().z_index = 1;
