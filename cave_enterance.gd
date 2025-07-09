extends StaticBody2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		z_index = -1;


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		z_index = 3;
